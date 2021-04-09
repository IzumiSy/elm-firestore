port module Worker exposing (main)

import Firestore
import Firestore.Config as Config


type alias Model =
    ()


init : () -> ( Model, Cmd msg )
init _ =
    let
        firestore =
            Firestore.init <|
                Config.new
                    { apiKey = "test-api-key"
                    , project = "test-project-id"
                    }
    in
    ( ()
    , Cmd.batch
        (List.map (\runner -> runner firestore)
            [ runTestGet
            , runTestInsert
            , runTestCreate
            , runTestUpsert
            ]
        )
    )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update _ _ =
    ( (), Cmd.none )


main : Program () Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- tests


runTestGet : Firestore.Firestore -> Cmd msg
runTestGet _ =
    testGetResult ()


port testGetResult : () -> Cmd msg


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
