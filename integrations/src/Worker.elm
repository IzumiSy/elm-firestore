port module Worker exposing (main)

import Firestore
import Firestore.Codec as Codec
import Firestore.Config as Config
import Firestore.Encode as FSEncode
import Firestore.Options.List as ListOptions
import Firestore.Options.Patch as PatchOptions
import Firestore.Query as Query
import Http
import Json.Encode as Encode
import List exposing (map)
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
    | RanTestListPageToken (Result Firestore.Error (Firestore.Documents User))
    | RunTestListDesc ()
    | RanTestListDesc (Result Firestore.Error (Firestore.Documents User))
    | RunTestListAsc ()
    | RanTestListAsc (Result Firestore.Error (Firestore.Documents User))
    | RunTestQueryFieldOp ()
    | RanTestQueryFieldOp (Result Firestore.Error (List (Firestore.Query User)))
    | RunTestInsert ()
    | RanTestInsert (Result Firestore.Error Firestore.Name)
    | RunTestCreate ()
    | RanTestCreate (Result Firestore.Error Firestore.Name)
    | RunTestUpsert ()
    | RanTestUpsert (Result Firestore.Error Firestore.Name)
    | RunTestPatch ()
    | RanTestPatch (Result Firestore.Error (Firestore.Document PatchedUser))
    | RunTestUpsertExisting ()
    | RanTestUpsertExisting (Result Firestore.Error (Firestore.Document User))
    | RunTestDelete ()
    | RanTestDelete (Result Firestore.Error (Firestore.Document User))
    | RunTestDeleteExisting ()
    | RanTestDeleteExisting (Result Firestore.Error ())
    | RunTestDeleteExistingFail ()
    | RanTestDeleteExistingFail (Result Firestore.Error ())


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
                |> Task.andThen
                    (\nextPageToken ->
                        nextPageToken
                            |> Maybe.map
                                (\pageToken ->
                                    model
                                        |> Firestore.path "users"
                                        |> Firestore.list
                                            (Codec.asDecoder codec)
                                            (ListOptions.default
                                                |> ListOptions.pageToken pageToken
                                                |> ListOptions.pageSize 2
                                                |> ListOptions.orderBy (ListOptions.Desc "age")
                                            )
                                )
                            |> Maybe.withDefault (Task.fail <| Firestore.Http_ <| Http.BadStatus -1)
                    )
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

        -- TestQueryFieldOp
        RunTestQueryFieldOp _ ->
            ( model
            , model
                |> Firestore.runQuery
                    (Codec.asDecoder codec)
                    (Query.new
                        |> Query.from "users"
                        |> Query.where_
                            (Query.fieldFilter "age" Query.LessThanOrEqual (Query.int 20))
                    )
                |> Task.attempt RanTestQueryFieldOp
            )

        RanTestQueryFieldOp result ->
            ( model
            , result
                |> Result.map
                    (List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryFieldOpResult
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

        -- TestUpsert
        RunTestUpsert _ ->
            ( model
            , model
                |> Firestore.path "users/user10"
                |> Firestore.upsert
                    (Codec.asDecoder codec)
                    (Codec.asEncoder codec { name = "jonathan", age = 21 })
                |> Task.map .name
                |> Task.attempt RanTestUpsert
            )

        RanTestUpsert result ->
            ( model
            , result
                |> Result.map (okValue << Encode.string << Firestore.id)
                |> Result.withDefault ngValue
                |> testUpsertResult
            )

        -- TestUpsertExisting
        RunTestUpsertExisting _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.upsert
                    (Codec.asDecoder codec)
                    (Codec.asEncoder codec { name = "user0updated", age = 0 })
                |> Task.andThen
                    (\_ ->
                        model
                            |> Firestore.path "users/user0"
                            |> Firestore.get (Codec.asDecoder codec)
                    )
                |> Task.attempt RanTestUpsertExisting
            )

        RanTestUpsertExisting result ->
            ( model
            , result
                |> Result.map
                    (.fields
                        >> .name
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testUpsertExistingResult
            )

        -- TestPatch
        RunTestPatch _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.patch
                    (Codec.asDecoder patchedCodec)
                    (PatchOptions.empty
                        |> PatchOptions.addDelete "age"
                        |> PatchOptions.addUpdate "name" (FSEncode.string "user0patched")
                    )
                |> Task.attempt RanTestPatch
            )

        RanTestPatch result ->
            ( model
            , result
                |> Result.map
                    (.fields
                        >> .name
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testPatchResult
            )

        -- TestDelete
        RunTestDelete _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.delete
                |> Task.andThen
                    (\_ ->
                        model
                            |> Firestore.path "users/user0"
                            |> Firestore.get (Codec.asDecoder codec)
                    )
                |> Task.attempt RanTestDelete
            )

        RanTestDelete result ->
            ( model
            , testDeleteResult <|
                case result of
                    Err (Firestore.Response { status }) ->
                        case status of
                            -- resource expected to be deleted successfully
                            "NOT_FOUND" ->
                                okValue Encode.null

                            _ ->
                                ngValue

                    _ ->
                        ngValue
            )

        -- TestDeleteExisting
        RunTestDeleteExisting _ ->
            ( model
            , model
                |> Firestore.path "users/user0"
                |> Firestore.deleteExisting
                |> Task.attempt RanTestDeleteExisting
            )

        RanTestDeleteExisting result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testDeleteExistingResult
            )

        -- TestDeleteExistingFail
        RunTestDeleteExistingFail _ ->
            ( model
            , model
                |> Firestore.path "users/no_user"
                |> Firestore.deleteExisting
                |> Task.attempt RanTestDeleteExistingFail
            )

        RanTestDeleteExistingFail result ->
            ( model
            , testDeleteExistingFailResult <|
                case result of
                    Err (Firestore.Http_ (Http.BadStatus 404)) ->
                        okValue Encode.null

                    _ ->
                        ngValue
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


type alias PatchedUser =
    { name : String }


patchedCodec : Codec.Codec PatchedUser
patchedCodec =
    Codec.document PatchedUser
        |> Codec.required "name" .name Codec.string
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
        , runTestQueryFieldOp RunTestQueryFieldOp
        , runTestInsert RunTestInsert
        , runTestCreate RunTestCreate
        , runTestUpsert RunTestUpsert
        , runTestUpsertExisting RunTestUpsertExisting
        , runTestPatch RunTestPatch
        , runTestDelete RunTestDelete
        , runTestDeleteExisting RunTestDeleteExisting
        , runTestDeleteExistingFail RunTestDeleteExistingFail
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


port runTestQueryFieldOp : (() -> msg) -> Sub msg


port testQueryFieldOpResult : Encode.Value -> Cmd msg


port runTestInsert : (() -> msg) -> Sub msg


port testInsertResult : Encode.Value -> Cmd msg


port runTestCreate : (() -> msg) -> Sub msg


port testCreateResult : Encode.Value -> Cmd msg


port runTestUpsert : (() -> msg) -> Sub msg


port testUpsertResult : Encode.Value -> Cmd msg


port runTestUpsertExisting : (() -> msg) -> Sub msg


port testUpsertExistingResult : Encode.Value -> Cmd msg


port runTestPatch : (() -> msg) -> Sub msg


port testPatchResult : Encode.Value -> Cmd msg


port runTestDelete : (() -> msg) -> Sub msg


port testDeleteResult : Encode.Value -> Cmd msg


port runTestDeleteExisting : (() -> msg) -> Sub msg


port testDeleteExistingResult : Encode.Value -> Cmd msg


port runTestDeleteExistingFail : (() -> msg) -> Sub msg


port testDeleteExistingFailResult : Encode.Value -> Cmd msg
