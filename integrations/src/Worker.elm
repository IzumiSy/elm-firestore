port module Worker exposing (main)

import Firestore
import Firestore.Codec as Codec
import Firestore.Config as Config


type alias Model =
    ()


init : () -> ( Model, Cmd msg )
init _ =
    let
        firestore =
            { apiKey = "test-api-key"
            , project = "test-project-id"
            }
                |> Config.new
                |> Config.withHost "localhost" 8080
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


main : Program () Model ()
main =
    Platform.worker
        { init = init
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }



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


runTestInsert : Firestore.Firestore -> Cmd msg
runTestInsert firestore =
    let
        codec =
            Codec.document User
                |> Codec.required "name" .name Codec.string
                |> Codec.required "age" .age Codec.int
                |> Codec.build

        op =
            firestore
                |> Firestore.path "users"
                |> Firestore.insert (Codec.asDecoder codec) (Codec.asEncoder codec)
    in
    testInsertResult ()


port testInsertResult : () -> Cmd msg


runTestCreate : Firestore.Firestore -> Cmd msg
runTestCreate _ =
    testCreateResult ()


port testCreateResult : () -> Cmd msg


runTestUpsert : Firestore.Firestore -> Cmd msg
runTestUpsert _ =
    testUpsertResult ()


port testUpsertResult : () -> Cmd msg
