module Firestore exposing
    ( Firestore
    , configure, collection
    , get, patch, delete, begin, commit, query
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore

@docs configure, collection

@docs get, patch, delete, begin, commit, query

-}

import Dict
import Firestore.APIKey as APIKey exposing (APIKey)
import Firestore.DatabaseId as DatabaseId exposing (DatabaseId)
import Firestore.Decoder as Decoder
import Firestore.Path as Path exposing (Path)
import Firestore.ProjectId as ProjectId exposing (ProjectId)
import Http
import Json.Decode as Decode
import String.Interpolate as Interpolate
import Task
import Time


type Firestore
    = Firestore APIKey ProjectId DatabaseId Path


{-| Config record has all information which is required to send requests to Firestore through REST API
-}
type alias Config =
    { apiKey : APIKey
    , projectId : ProjectId
    , databaseId : DatabaseId
    }


{-| Builds a new Firestore connection with Config
-}
configure : Config -> Firestore
configure { apiKey, projectId, databaseId } =
    Firestore apiKey projectId databaseId Path.empty


{-| Drills down document paths with a specific path name.
This function is aimed to be chanind with pipeline operators in order to build up document path.

    firestore
        |> Firestore.collection "users"
        |> Firestore.collection "items"
        |> Firestore.collection "tags"
        |> Firestore.get
        |> Task.attempt GotUserItemTags

Of course, you can make it a single string

    firestore
        |> Firestore.collection "users/items/tags"
        |> Firestore.get
        |> Task.attempt GotUserItemTags

-}
collection : String -> Firestore -> Firestore
collection pathValue (Firestore apiKey projectId databaseId path) =
    Firestore apiKey projectId databaseId (Path.append pathValue path)



-- Request


get : Decode.Decoder a -> Firestore -> Task.Task Http.Error (Decoder.Response a)
get fieldDecoder (Firestore apiKey projectId databaseId path) =
    Http.task
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
        , timeout = Nothing
        , resolver = jsonResolver (Decoder.response fieldDecoder)
        }


patch : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
patch _ _ =
    Cmd.none


delete : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
delete _ _ =
    Cmd.none


begin : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
begin _ _ =
    Cmd.none


commit : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
commit _ _ =
    Cmd.none


query : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
query _ _ =
    Cmd.none



-- Resolver


jsonResolver : Decode.Decoder a -> Http.Resolver Http.Error a
jsonResolver decoder =
    Http.stringResolver <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (Http.BadUrl url)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ { statusCode } _ ->
                    Err (Http.BadStatus statusCode)

                Http.GoodStatus_ metadata body ->
                    case Decode.decodeString decoder body of
                        Err _ ->
                            Err (Http.BadBody body)

                        Ok result ->
                            Ok result
