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
import List
import Maybe
import Result.Extra as ExResult
import Task


type alias Flag =
    { apiKey : String
    , project : String
    , host : String
    , port_ : Int
    }


type alias Model =
    Firestore.Firestore


init : Flag -> ( Model, Cmd Msg )
init { apiKey, project, host, port_ } =
    ( { apiKey = apiKey
      , project = project
      }
        |> Config.new
        |> Config.withHost host port_
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
    | RunTestQueryCompositeOp ()
    | RanTestQueryCompositeOp (Result Firestore.Error (List (Firestore.Query User)))
    | RunTestQueryUnaryOp ()
    | RanTestQueryUnaryOp (Result Firestore.Error (List (Firestore.Query User)))
    | RunTestQueryOrderBy ()
    | RanTestQueryOrderBy (Result Firestore.Error (List (Firestore.Query User)))
    | RunTestQueryEmpty ()
    | RanTestQueryEmpty (Result Firestore.Error (List (Firestore.Query User)))
    | RunTestQueryComplex ()
    | RanTestQueryComplex (Result Firestore.Error (List (Firestore.Query User)))
    | RunTestQuerySubCollection ()
    | RanTestQuerySubCollection (Result Firestore.Error (List (Firestore.Query Extra)))
    | RunTestQueryCollectionGroup ()
    | RanTestQueryCollectionGroup (Result Firestore.Error (List (Firestore.Query Extra)))
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
    | RunTestTransaction ()
    | RanTestTransaction (Result Firestore.Error Firestore.CommitTime)
    | RunTestGetTx ()
    | RanTestGetTx (Result Firestore.Error Firestore.CommitTime)
    | RunTestListTx ()
    | RanTestListTx (Result Firestore.Error Firestore.CommitTime)
    | RunTestQueryTx ()
    | RanTestQueryTx (Result Firestore.Error Firestore.CommitTime)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- TestGet
        RunTestGet _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user0"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen (Firestore.get (Codec.asDecoder codec))
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.list
                        (Codec.asDecoder codec)
                        (ListOptions.pageSize 3 ListOptions.default)
                    )
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.list
                        (Codec.asDecoder codec)
                        (ListOptions.pageSize 2 ListOptions.default)
                    )
                |> Task.map .nextPageToken
                |> Task.andThen
                    (Maybe.map
                        (\pageToken ->
                            model
                                |> Firestore.root
                                |> Firestore.collection "users"
                                |> Firestore.build
                                |> ExResult.toTask
                                |> Task.andThen
                                    (Firestore.list
                                        (Codec.asDecoder codec)
                                        (ListOptions.default
                                            |> ListOptions.pageToken pageToken
                                            |> ListOptions.pageSize 2
                                            |> ListOptions.orderBy (ListOptions.Desc "age")
                                        )
                                    )
                        )
                        >> Maybe.withDefault (Task.fail <| Firestore.Http_ <| Http.BadStatus -1)
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.list
                        (Codec.asDecoder codec)
                        (ListOptions.orderBy
                            (ListOptions.Desc "age")
                            ListOptions.default
                        )
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.list
                        (Codec.asDecoder codec)
                        (ListOptions.orderBy
                            (ListOptions.Asc "age")
                            ListOptions.default
                        )
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
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder codec)
                        (Query.new
                            |> Query.collection "users"
                            |> Query.where_
                                (Query.fieldFilter "age" Query.LessThanOrEqual (Query.int 20))
                        )
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

        -- TestQueryCompsiteOp
        RunTestQueryCompositeOp _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder codec)
                        (Query.new
                            |> Query.collection "users"
                            |> Query.where_
                                (Query.compositeFilter Query.And
                                    (Query.fieldFilter "age" Query.GreaterThanOrEqual (Query.int 10))
                                    [ Query.fieldFilter "age" Query.LessThan (Query.int 30) ]
                                )
                        )
                    )
                |> Task.attempt RanTestQueryCompositeOp
            )

        RanTestQueryCompositeOp result ->
            ( model
            , result
                |> Result.map
                    (List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryCompositeOpResult
            )

        -- TestQueryUnaryOp
        RunTestQueryUnaryOp _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder codec)
                        (Query.new
                            |> Query.collection "users"
                            |> Query.where_
                                (Query.unaryFilter "name" Query.IsNull)
                        )
                    )
                |> Task.attempt RanTestQueryUnaryOp
            )

        RanTestQueryUnaryOp result ->
            ( model
            , result
                |> Result.map
                    (List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryUnaryOpResult
            )

        -- TestQueryOrderBy
        RunTestQueryOrderBy _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder codec)
                        (Query.new
                            |> Query.collection "users"
                            |> Query.orderBy "age" Query.Descending
                            |> Query.where_
                                (Query.fieldFilter "age" Query.GreaterThanOrEqual (Query.int 20))
                        )
                    )
                |> Task.attempt RanTestQueryOrderBy
            )

        RanTestQueryOrderBy result ->
            ( model
            , result
                |> Result.map
                    (List.head
                        >> Maybe.map (.document >> .fields >> .name)
                        >> Maybe.withDefault "unknown"
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryOrderByResult
            )

        -- TestQueryEmpty
        RunTestQueryEmpty _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder codec)
                        (Query.new
                            |> Query.collection "users"
                            |> Query.where_
                                (Query.fieldFilter "name" Query.Equal (Query.string "name_not_found_on_seed"))
                        )
                    )
                |> Task.attempt RanTestQueryEmpty
            )

        RanTestQueryEmpty result ->
            ( model
            , result
                |> Result.map
                    (List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryEmptyResult
            )

        -- TestQueryComplex
        RunTestQueryComplex _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder codec)
                        (Query.new
                            |> Query.collection "users"
                            |> Query.limit 2
                            |> Query.offset 2
                            |> Query.orderBy "age" Query.Descending
                            |> Query.where_
                                (Query.compositeFilter Query.And
                                    (Query.fieldFilter "age" Query.GreaterThanOrEqual (Query.int 10))
                                    [ Query.fieldFilter "age" Query.LessThanOrEqual (Query.int 40) ]
                                )
                        )
                    )
                |> Task.attempt RanTestQueryComplex
            )

        RanTestQueryComplex result ->
            ( model
            , result
                |> Result.map
                    (List.head
                        >> Maybe.map (.document >> .fields >> .name)
                        >> Maybe.withDefault "unknown"
                        >> Encode.string
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryComplexResult
            )

        -- TestQuerySubCollection
        RunTestQuerySubCollection _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user0"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder extraCodec)
                        (Query.new
                            |> Query.collection "extras"
                            |> Query.where_
                                (Query.fieldFilter "type" Query.Equal (Query.string "tel"))
                        )
                    )
                |> Task.attempt RanTestQuerySubCollection
            )

        RanTestQuerySubCollection result ->
            ( model
            , result
                |> Result.map
                    (List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQuerySubCollectionResult
            )

        -- TestQueryCollectionGroup
        RunTestQueryCollectionGroup _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.runQuery
                        (Codec.asDecoder extraCodec)
                        (Query.new
                            |> Query.collectionGroup "extras"
                            |> Query.where_
                                (Query.fieldFilter "type" Query.Equal (Query.string "occupation"))
                        )
                    )
                |> Task.attempt RanTestQueryCollectionGroup
            )

        RanTestQueryCollectionGroup result ->
            ( model
            , result
                |> Result.map
                    (List.length
                        >> Encode.int
                        >> okValue
                    )
                |> Result.withDefault ngValue
                |> testQueryCollectionGroupResult
            )

        -- TestInsert
        RunTestInsert _ ->
            ( model
            , model
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.insert
                        (Codec.asDecoder codec)
                        (Codec.asEncoder codec { name = "thomas", age = 26 })
                    )
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.create
                        (Codec.asDecoder codec)
                        { id = "jessy"
                        , document = Codec.asEncoder codec { name = "jessy", age = 27 }
                        }
                    )
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user10"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.upsert
                        (Codec.asDecoder codec)
                        (Codec.asEncoder codec { name = "jonathan", age = 21 })
                    )
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user0"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.upsert
                        (Codec.asDecoder codec)
                        (Codec.asEncoder codec { name = "user0updated", age = 0 })
                    )
                |> Task.andThen
                    (\_ ->
                        model
                            |> Firestore.root
                            |> Firestore.collection "users"
                            |> Firestore.document "user0"
                            |> Firestore.build
                            |> ExResult.toTask
                            |> Task.andThen (Firestore.get (Codec.asDecoder codec))
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user0"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen
                    (Firestore.patch
                        (Codec.asDecoder patchedCodec)
                        (PatchOptions.empty
                            |> PatchOptions.addDelete "age"
                            |> PatchOptions.addUpdate "name" (FSEncode.string "user0patched")
                        )
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user0"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen Firestore.delete
                |> Task.andThen
                    (\_ ->
                        model
                            |> Firestore.root
                            |> Firestore.collection "users"
                            |> Firestore.document "user0"
                            |> Firestore.build
                            |> ExResult.toTask
                            |> Task.andThen (Firestore.get (Codec.asDecoder codec))
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user0"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen Firestore.deleteExisting
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
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "no_user"
                |> Firestore.build
                |> ExResult.toTask
                |> Task.andThen Firestore.deleteExisting
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

        -- TestTransaction
        RunTestTransaction _ ->
            ( model
            , model
                |> Firestore.begin
                |> Task.andThen
                    (\transaction ->
                        let
                            users =
                                model
                                    |> Firestore.root
                                    |> Firestore.collection "users"

                            user0r =
                                users
                                    |> Firestore.document "user0"
                                    |> Firestore.build

                            user1r =
                                users
                                    |> Firestore.document "user1"
                                    |> Firestore.build

                            user2r =
                                users
                                    |> Firestore.document "user2"
                                    |> Firestore.build
                        in
                        ExResult.toTask <|
                            Result.map3
                                (\user0 user1 user2 ->
                                    transaction
                                        |> Firestore.updateTx user0 (Codec.asEncoder codec { name = "user0updated", age = 0 })
                                        |> Firestore.updateTx user1 (Codec.asEncoder codec { name = "user1updated", age = 10 })
                                        |> Firestore.deleteTx user2
                                )
                                user0r
                                user1r
                                user2r
                    )
                |> Task.andThen (Firestore.commit model)
                |> Task.attempt RanTestTransaction
            )

        RanTestTransaction result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testTransactionResult
            )

        -- TestGetTx
        RunTestGetTx _ ->
            ( model
            , model
                |> Firestore.begin
                |> Task.andThen
                    (\transaction ->
                        model
                            |> Firestore.root
                            |> Firestore.collection "users"
                            |> Firestore.document "user0"
                            |> Firestore.build
                            |> ExResult.toTask
                            |> Task.andThen (Firestore.getTx transaction (Codec.asDecoder codec))
                            |> Task.map (\result -> ( transaction, result ))
                    )
                |> Task.andThen
                    (\( transaction, { fields } ) ->
                        model
                            |> Firestore.root
                            |> Firestore.collection "users"
                            |> Firestore.document "user0"
                            |> Firestore.build
                            |> ExResult.toTask
                            |> Task.andThen
                                (\path ->
                                    transaction
                                        |> Firestore.updateTx path (Codec.asEncoder codec { name = fields.name ++ "txUpdated", age = 0 })
                                        |> Firestore.commit model
                                )
                    )
                |> Task.attempt RanTestGetTx
            )

        RanTestGetTx result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testGetTxResult
            )

        -- TestListTx
        RunTestListTx _ ->
            ( model
            , model
                |> Firestore.begin
                |> Task.andThen
                    (\transaction ->
                        model
                            |> Firestore.root
                            |> Firestore.collection "users"
                            |> Firestore.build
                            |> ExResult.toTask
                            |> Task.andThen (Firestore.listTx transaction (Codec.asDecoder codec) ListOptions.default)
                            |> Task.map (\{ documents } -> ( transaction, documents ))
                    )
                |> Task.andThen
                    (\( transaction, documents ) ->
                        documents
                            |> List.map
                                (\{ name, fields } ->
                                    model
                                        |> Firestore.root
                                        |> Firestore.collection "users"
                                        |> Firestore.document (Firestore.id name)
                                        |> Firestore.build
                                        |> (\pathR -> ( pathR, fields ))
                                )
                            |> List.foldr
                                (\( pathR, fields ) transaction_ ->
                                    pathR
                                        |> Result.map
                                            (\path ->
                                                Firestore.updateTx
                                                    path
                                                    (Codec.asEncoder codec { name = fields.name ++ "txUpdated", age = fields.age })
                                                    transaction_
                                            )
                                        |> Result.withDefault transaction_
                                )
                                transaction
                            |> Firestore.commit model
                    )
                |> Task.attempt RanTestListTx
            )

        RanTestListTx result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testListTxResult
            )

        -- TestQueryTx
        RunTestQueryTx _ ->
            ( model
            , model
                |> Firestore.begin
                |> Task.andThen
                    (\transaction ->
                        model
                            |> Firestore.root
                            |> Firestore.build
                            |> ExResult.toTask
                            |> Task.andThen
                                (Firestore.runQueryTx
                                    transaction
                                    (Codec.asDecoder codec)
                                    (Query.new
                                        |> Query.collection "users"
                                        |> Query.where_
                                            (Query.fieldFilter "age" Query.LessThanOrEqual (Query.int 20))
                                    )
                                )
                            |> Task.map (\results -> ( transaction, results ))
                    )
                |> Task.andThen
                    (\( transaction, results ) ->
                        results
                            |> List.map
                                (\{ document } ->
                                    model
                                        |> Firestore.root
                                        |> Firestore.collection "users"
                                        |> Firestore.document (Firestore.id document.name)
                                        |> Firestore.build
                                        |> (\pathR -> ( pathR, document ))
                                )
                            |> List.foldr
                                (\( pathR, document ) transaction_ ->
                                    pathR
                                        |> Result.map
                                            (\path ->
                                                Firestore.updateTx
                                                    path
                                                    (Codec.asEncoder codec
                                                        { name = document.fields.name ++ "txUpdated"
                                                        , age = document.fields.age
                                                        }
                                                    )
                                                    transaction_
                                            )
                                        |> Result.withDefault transaction_
                                )
                                transaction
                            |> Firestore.commit model
                    )
                |> Task.attempt RanTestQueryTx
            )

        RanTestQueryTx result ->
            ( model
            , result
                |> Result.map (\_ -> okValue Encode.null)
                |> Result.withDefault ngValue
                |> testQueryTxResult
            )


main : Program Flag Model Msg
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


type alias Extra =
    { type_ : String
    , value : String
    }


extraCodec : Codec.Codec Extra
extraCodec =
    Codec.document Extra
        |> Codec.required "type" .type_ Codec.string
        |> Codec.required "value" .value Codec.string
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
        , runTestQueryCompositeOp RunTestQueryCompositeOp
        , runTestQueryUnaryOp RunTestQueryUnaryOp
        , runTestQueryOrderBy RunTestQueryOrderBy
        , runTestQueryEmpty RunTestQueryEmpty
        , runTestQueryComplex RunTestQueryComplex
        , runTestQuerySubCollection RunTestQuerySubCollection
        , runTestQueryCollectionGroup RunTestQueryCollectionGroup
        , runTestInsert RunTestInsert
        , runTestCreate RunTestCreate
        , runTestUpsert RunTestUpsert
        , runTestUpsertExisting RunTestUpsertExisting
        , runTestPatch RunTestPatch
        , runTestDelete RunTestDelete
        , runTestDeleteExisting RunTestDeleteExisting
        , runTestDeleteExistingFail RunTestDeleteExistingFail
        , runTestTransaction RunTestTransaction
        , runTestGetTx RunTestGetTx
        , runTestListTx RunTestListTx
        , runTestQueryTx RunTestQueryTx
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


port runTestQueryCompositeOp : (() -> msg) -> Sub msg


port testQueryCompositeOpResult : Encode.Value -> Cmd msg


port runTestQueryUnaryOp : (() -> msg) -> Sub msg


port testQueryUnaryOpResult : Encode.Value -> Cmd msg


port runTestQueryOrderBy : (() -> msg) -> Sub msg


port testQueryOrderByResult : Encode.Value -> Cmd msg


port runTestQueryEmpty : (() -> msg) -> Sub msg


port testQueryEmptyResult : Encode.Value -> Cmd msg


port runTestQueryComplex : (() -> msg) -> Sub msg


port testQueryComplexResult : Encode.Value -> Cmd msg


port runTestQuerySubCollection : (() -> msg) -> Sub msg


port testQuerySubCollectionResult : Encode.Value -> Cmd msg


port runTestQueryCollectionGroup : (() -> msg) -> Sub msg


port testQueryCollectionGroupResult : Encode.Value -> Cmd msg


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


port runTestTransaction : (() -> msg) -> Sub msg


port testTransactionResult : Encode.Value -> Cmd msg


port runTestGetTx : (() -> msg) -> Sub msg


port testGetTxResult : Encode.Value -> Cmd msg


port runTestListTx : (() -> msg) -> Sub msg


port testListTxResult : Encode.Value -> Cmd msg


port runTestQueryTx : (() -> msg) -> Sub msg


port testQueryTxResult : Encode.Value -> Cmd msg
