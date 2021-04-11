port module Worker exposing (main)

import Firestore
import Firestore.Codec as Codec
import Firestore.Config as Config
import Firestore.Options.List as ListOptions
import Json.Encode as Encode
import Task


type alias Model =
    ()


init : () -> ( Model, Cmd Msg )
init _ =
    let
        firestore =
            { apiKey = "test-api-key"
            , project = "elm-firestore-test"
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
    = RanTestGet (Result Firestore.Error (Firestore.Document User))
    | RanTestList (Result Firestore.Error (Firestore.Documents User))
    | RanTestInsert (Result Firestore.Error Firestore.Name)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        RanTestGet result ->
            ( model
            , result
                |> Result.map (\value -> okValue (Encode.string value.fields.name))
                |> Result.withDefault ngValue
                |> testGetResult
            )

        RanTestList result ->
            ( model
            , result
                |> Result.map (\value -> okValue (Encode.int <| List.length value.documents))
                |> Result.withDefault ngValue
                |> testListResult
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
        , subscriptions = \_ -> Sub.none
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


codec : Codec.Codec User
codec =
    Codec.document User
        |> Codec.required "name" .name Codec.string
        |> Codec.required "age" .age Codec.int
        |> Codec.build


runTestGet : Firestore.Firestore -> Cmd Msg
runTestGet firestore =
    firestore
        |> Firestore.path "users/user0"
        |> Firestore.get (Codec.asDecoder codec)
        |> Task.attempt RanTestGet


port testGetResult : Encode.Value -> Cmd msg


runTestList : Firestore.Firestore -> Cmd Msg
runTestList firestore =
    firestore
        |> Firestore.path "users"
        |> Firestore.list (Codec.asDecoder codec) ListOptions.default
        |> Task.attempt RanTestList


port testListResult : Encode.Value -> Cmd msg


type alias User =
    { name : String
    , age : Int
    }


runTestInsert : Firestore.Firestore -> Cmd Msg
runTestInsert firestore =
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
