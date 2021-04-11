port module Worker exposing (main)

import Firestore
import Firestore.Config as Config


type alias Model =
    ()


init : () -> ( Model, Cmd msg )
init _ =
    let
        config =
            Config.withHost "localhost" 8080 <|
                Config.new
                    { apiKey = "test-api-key"
                    , project = "test-project-id"
                    }

        firestore =
            Firestore.init config
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


runTestInsert : Firestore.Firestore -> Cmd msg
runTestInsert _ =
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
