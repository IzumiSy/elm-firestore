port module Worker exposing (main)

import Firestore
import Firestore.Codec as Codec
import Firestore.Config as Config
import Json.Encode as Encode
import Task


type alias Model =
    ()


init : () -> ( Model, Cmd Msg )
init _ =
    let
        firestore =
            { apiKey = "test-api-key"
            , project = "test-project-id"
            }
                |> Config.new
                |> Config.withHost "http://localhost" 8080
                |> Firestore.init
    in
    ( ()
    , Cmd.batch
        (List.map (\runner -> runner firestore)
            [ runTestGet
            , runTestList
            , runTestInsert
            , runTestCreate
            , runTestUpsert
            ]
        )
    )


type Msg
    = NoOp
    | RanTestInsert (Result Firestore.Error Firestore.Name)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

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
        , subscriptions = \_ -> Sub.none
        }



-- encoder


okValue : Encode.Value -> Encode.Value
okValue values =
    Encode.object
        [ ( "success", Encode.bool True )
        , ( "values", values )
        ]


ngValue : Encode.Value
ngValue =
    Encode.object
        [ ( "success", Encode.bool False )
        ]



-- tests


runTestGet : Firestore.Firestore -> Cmd msg
runTestGet _ =
    testGetResult ()


port testGetResult : () -> Cmd msg


runTestList : Firestore.Firestore -> Cmd msg
runTestList _ =
    testListResult ()


port testListResult : () -> Cmd msg


type alias User =
    { name : String
    , age : Int
    }


runTestInsert : Firestore.Firestore -> Cmd Msg
runTestInsert firestore =
    let
        codec =
            Codec.document User
                |> Codec.required "name" .name Codec.string
                |> Codec.required "age" .age Codec.int
                |> Codec.build
    in
    firestore
        |> Firestore.path "users"
        |> Firestore.insert
            (Codec.asDecoder codec)
            (Codec.asEncoder codec { name = "thomas", age = 26 })
        |> Task.map
            (\insertedDoc ->
                insertedDoc.name
            )
        |> Task.attempt RanTestInsert


port testInsertResult : Encode.Value -> Cmd msg


runTestCreate : Firestore.Firestore -> Cmd msg
runTestCreate _ =
    testCreateResult ()


port testCreateResult : () -> Cmd msg


runTestUpsert : Firestore.Firestore -> Cmd msg
runTestUpsert _ =
    testUpsertResult ()


port testUpsertResult : () -> Cmd msg
