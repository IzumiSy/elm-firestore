port module Worker exposing (main)

import Firestore exposing (Firestore)
import Firestore.Codec as Codec
import Firestore.Config as Config
import Firestore.Options.List as ListOptions
import Html
import Http
import Json.Encode as Encode
import Task


type alias Model =
    Firestore.Firestore


init : () -> ( Model, Cmd Msg )
init _ =
    ( { apiKey = "test-api-key"
      , project = "elm-firestore-test"
      }
        |> Config.new
        |> Config.withHost "http://localhost" 8080
        |> Firestore.init
    , Cmd.none
    )


type Msg
    = RunTestGet ()
    | RanTestGet (Result Firestore.Error (Firestore.Document User))
    | RunTestListPageSize ()
    | RanTestListPageSize (Result Firestore.Error (Firestore.Documents User))
    | RunTestListPageToken ()
    | RunTestListPageTokenStep (Result Firestore.Error (Maybe ListOptions.PageToken))
    | RanTestListPageToken (Result Firestore.Error (Firestore.Documents User))
    | RunTestListDesc ()
    | RanTestListDesc (Result Firestore.Error (Firestore.Documents User))
    | RunTestListAsc ()
    | RanTestListAsc (Result Firestore.Error (Firestore.Documents User))
    | RunTestInsert ()
    | RanTestInsert (Result Firestore.Error Firestore.Name)
    | RunTestCreate ()
    | RanTestCreate (Result Firestore.Error Firestore.Name)
    | RunTestDelete ()
    | RunTestDeleteStep (Result Firestore.Error ())
    | RanTestDelete (Result Firestore.Error (Firestore.Document User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- TestGet
        RunTestGet _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.get (Codec.asDecoder codec)
                |> Task.attempt RanTestGet
            )

        RanTestGet result ->
            ( model
            , result
                |> Result.map
                    (.fields
                        >> .name
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testGetResult
            )

        -- TestListPageSize
        RunTestListPageSize _ ->
            ( model
            , model
                |> Firestore.path "users"
                |> Firestore.list
                    (Codec.asDecoder codec)
                    (ListOptions.pageSize 3 ListOptions.default)
                |> Task.attempt RanTestListPageSize
            )

        RanTestListPageSize result ->
            ( model
            , result
                |> Result.map
                    (.documents
                        >> List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testListPageSizeResult
            )

        -- TestListPageToken
        RunTestListPageToken _ ->
            ( model
            , model
                |> Firestore.path "users"
                |> Firestore.list
                    (Codec.asDecoder codec)
                    (ListOptions.pageSize 2 ListOptions.default)
                |> Task.map .nextPageToken
                |> Task.attempt RunTestListPageTokenStep
            )

        RunTestListPageTokenStep result ->
            ( model
            , result
                |> Result.toMaybe
                |> Maybe.andThen
                    (Maybe.map
                        (\pageToken ->
                            model
                                |> Firestore.path "users"
                                |> Firestore.list
                                    (Codec.asDecoder codec)
                                    (ListOptions.default
                                        |> ListOptions.pageToken pageToken
                                        |> ListOptions.pageSize 3
                                        |> ListOptions.orderBy (ListOptions.Desc "age")
                                    )
                        )
                    )
                |> Maybe.withDefault (Task.fail <| Firestore.Http_ <| Http.BadStatus 404)
                |> Task.attempt RanTestListPageToken
            )

        RanTestListPageToken result ->
            ( model
            , result
                |> Result.map
                    (.documents
                        >> List.head
                        >> Maybe.map (.fields >> .name)
                        >> Maybe.withDefault "unknown"
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testListPageTokenResult
            )

        -- TestListDesc
        RunTestListDesc _ ->
            ( model
            , model
                |> Firestore.path "users"
                |> Firestore.list
                    (Codec.asDecoder codec)
                    (ListOptions.orderBy
                        (ListOptions.Desc "age")
                        ListOptions.default
                    )
                |> Task.attempt RanTestListDesc
            )

        RanTestListDesc result ->
            ( model
            , result
                |> Result.map
                    (.documents
                        >> List.head
                        >> Maybe.map (.fields >> .name)
                        >> Maybe.withDefault "unknown"
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testListDescResult
            )

        -- TestListAsc
        RunTestListAsc _ ->
            ( model
            , model
                |> Firestore.path "users"
                |> Firestore.list
                    (Codec.asDecoder codec)
                    (ListOptions.orderBy
                        (ListOptions.Asc "age")
                        ListOptions.default
                    )
                |> Task.attempt RanTestListAsc
            )

        RanTestListAsc result ->
            ( model
            , result
                |> Result.map
                    (.documents
                        >> List.head
                        >> Maybe.map (.fields >> .name)
                        >> Maybe.withDefault "unknown"
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testListAscResult
            )

        -- TestInsert
        RunTestInsert _ ->
            ( model
            , model
                |> Firestore.path "users"
                |> Firestore.insert
                    (Codec.asDecoder codec)
                    (Codec.asEncoder codec { name = "thomas", age = 26 })
                |> Task.map .name
                |> Task.attempt RanTestInsert
            )

        RanTestInsert result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testInsertResult
            )

        -- TestCreate
        RunTestCreate _ ->
            ( model
            , model
                |> Firestore.path "users"
                |> Firestore.create
                    (Codec.asDecoder codec)
                    { id = "jessy"
                    , document = Codec.asEncoder codec { name = "jessy", age = 27 }
                    }
                |> Task.map .name
                |> Task.attempt RanTestCreate
            )

        RanTestCreate result ->
            ( model
            , result
                |> Result.map (okValue << Encode.string << Firestore.id)
                |> Result.withDefault ngValue
                |> testCreateResult
            )

        -- TestDelete
        RunTestDelete _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.delete
                |> Task.attempt RunTestDeleteStep
            )

        RunTestDeleteStep _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.get (Codec.asDecoder codec)
                |> Task.attempt RanTestDelete
            )

        RanTestDelete result ->
            ( model
            , result
                |> Result.map (\_ -> ngValue)
                |> Result.withDefault (okValue Encode.null)
                |> testDeleteResult
            )


main : Program () Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }



-- encoder


okValue : Encode.Value -> Encode.Value
okValue value =
    Encode.object
        [ ( "success", Encode.bool True )
        , ( "value", value )
        ]


ngValue : Encode.Value
ngValue =
    Encode.object
        [ ( "success", Encode.bool False )
        ]



-- tests


type alias User =
    { name : String
    , age : Int
    }


codec : Codec.Codec User
codec =
    Codec.document User
        |> Codec.required "name" .name Codec.string
        |> Codec.required "age" .age Codec.int
        |> Codec.build



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ runTestGet RunTestGet
        , runTestListPageToken RunTestListPageToken
        , runTestListPageSize RunTestListPageSize
        , runTestListDesc RunTestListDesc
        , runTestListAsc RunTestListAsc
        , runTestInsert RunTestInsert
        , runTestCreate RunTestCreate
        , runTestDelete RunTestDelete
        ]



-- ports


port runTestGet : (() -> msg) -> Sub msg


port testGetResult : Encode.Value -> Cmd msg


port runTestListPageToken : (() -> msg) -> Sub msg


port testListPageTokenResult : Encode.Value -> Cmd msg


port runTestListPageSize : (() -> msg) -> Sub msg


port testListPageSizeResult : Encode.Value -> Cmd msg


port runTestListDesc : (() -> msg) -> Sub msg


port testListDescResult : Encode.Value -> Cmd msg


port runTestListAsc : (() -> msg) -> Sub msg


port testListAscResult : Encode.Value -> Cmd msg


port runTestInsert : (() -> msg) -> Sub msg


port testInsertResult : Encode.Value -> Cmd msg


port runTestCreate : (() -> msg) -> Sub msg


port testCreateResult : Encode.Value -> Cmd msg


port runTestDelete : (() -> msg) -> Sub msg


port testDeleteResult : Encode.Value -> Cmd msg
