module Firestore exposing
    ( Firestore
    , collection
    , configure
    , delete
    , get
    , patch
    )

import Firestore.APIKey as APIKey exposing (APIKey)
import Firestore.DatabaseId as DatabaseId exposing (DatabaseId)
import Firestore.Path as Path exposing (Path)
import Firestore.ProjectId as ProjectId exposing (ProjectId)
import Http
import String.Interpolate as Interpolate


type Firestore
    = Firestore APIKey ProjectId DatabaseId Path


type alias Config =
    { apiKey : APIKey
    , projectId : ProjectId
    , databaseId : DatabaseId
    }


configure : Config -> Firestore
configure { apiKey, projectId, databaseId } =
    Firestore apiKey projectId databaseId Path.empty


collection : String -> Firestore -> Firestore
collection pathValue (Firestore apiKey projectId databaseId path) =
    Firestore apiKey projectId databaseId (Path.append pathValue path)


get : (Result Http.Error () -> msg) -> Firestore -> Cmd msg
get msg (Firestore apiKey projectId databaseId path) =
    Http.request
        { method = "GET"
        , headers = []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , DatabaseId.unwrap databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.emptyBody
        , expect = Http.expectWhatever msg -- TODO: Here must be Http.expectJson
        , timeout = Nothing
        , tracker = Nothing
        }


patch : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
patch _ _ =
    Cmd.none


delete : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
delete _ _ =
    Cmd.none
