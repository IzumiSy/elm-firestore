port module Worker exposing (main)

import Firestore exposing (Firestore)
import Firestore.Codec as Codec
import Firestore.Config as Config
import Firestore.Options.List as ListOptions
import Html exposing (fieldset)
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
    | RunTestListDesc ()
    | RanTestListDesc (Result Firestore.Error (Firestore.Documents User))
    | RunTestListAsc ()
    | RanTestListAsc (Result Firestore.Error (Firestore.Documents User))
    | RunTestInsert ()
    | RanTestInsert (Result Firestore.Error Firestore.Name)


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
                |> Task.map
                    (\insertedDoc ->
                        insertedDoc.name
                    )
                |> Task.attempt RanTestInsert
            )

        RanTestInsert result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testInsertResult
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
        , runTestListPageSize RunTestListPageSize
        , runTestListDesc RunTestListDesc
        , runTestListAsc RunTestListAsc
        , runTestInsert RunTestInsert
        ]



-- ports


port runTestGet : (() -> msg) -> Sub msg


port testGetResult : Encode.Value -> Cmd msg


port runTestListPageSize : (() -> msg) -> Sub msg


port testListPageSizeResult : Encode.Value -> Cmd msg


port runTestListDesc : (() -> msg) -> Sub msg


port testListDescResult : Encode.Value -> Cmd msg


port runTestListAsc : (() -> msg) -> Sub msg


port testListAscResult : Encode.Value -> Cmd msg


port runTestInsert : (() -> msg) -> Sub msg


port testInsertResult : Encode.Value -> Cmd msg
