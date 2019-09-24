module Firestore exposing
    ( Firestore
    , configure, collection
    , get, patch, delete, begin, commit
    , Response, Document, Error, ErrorInfo
    , responseDecoder
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore

@docs configure, collection

@docs get, patch, delete, begin, commit

@docs Response, Document, Error, ErrorInfo

-}

import Dict
import Firestore.Config.APIKey as APIKey exposing (APIKey)
import Firestore.Config.DatabaseId as DatabaseId exposing (DatabaseId)
import Firestore.Config.ProjectId as ProjectId exposing (ProjectId)
import Firestore.Path as Path exposing (Path)
import Firestore.Transaction as Transaction
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
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


get : Decode.Decoder a -> Firestore -> Task.Task Http.Error (Response a)
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
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


patch : Decode.Value -> Decode.Decoder a -> Firestore -> Task.Task Http.Error (Response a)
patch body fieldDecoder (Firestore apiKey projectId databaseId path) =
    Http.task
        { method = "PATCH"
        , headers = []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , DatabaseId.unwrap databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.jsonBody body
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


delete : Firestore -> Task.Task Http.Error ()
delete (Firestore apiKey projectId databaseId path) =
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
        , resolver = emptyResolver
        }


begin : Firestore -> Task.Task Http.Error Transaction.Transaction
begin (Firestore apiKey projectId databaseId path) =
    Task.map Transaction.new <|
        Http.task
            { method = "POST"
            , headers = []
            , url =
                Interpolate.interpolate
                    "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents:beginTransaction?key={2}"
                    [ ProjectId.unwrap projectId
                    , DatabaseId.unwrap databaseId
                    , APIKey.unwrap apiKey
                    ]
            , body = Http.emptyBody
            , timeout = Nothing
            , resolver = jsonResolver transactionResolver
            }


commit : Decode.Value -> Firestore -> Task.Task Http.Error Commit
commit body (Firestore apiKey projectId databaseId path) =
    Http.task
        { method = "POST"
        , headers = []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents:commit?key={2}"
                [ ProjectId.unwrap projectId
                , DatabaseId.unwrap databaseId
                , APIKey.unwrap apiKey
                ]
        , body = Http.jsonBody body
        , timeout = Nothing
        , resolver = jsonResolver commitResolver
        }



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


emptyResolver : Http.Resolver Http.Error ()
emptyResolver =
    Http.stringResolver <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (Http.BadUrl url)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata _ ->
                    Err (Http.BadStatus metadata.statusCode)

                Http.GoodStatus_ _ _ ->
                    Ok ()



-- Decoder
{- `responseDecoder` function is being exposed, but this it only for unit testing -}


type alias Response a =
    { documents : List (Document a)
    }


responseDecoder : Decode.Decoder a -> Decode.Decoder (Response a)
responseDecoder fieldDecoder =
    Decode.succeed Response
        |> Pipeline.required "documents" (Decode.list (documentDecoder fieldDecoder))


type alias Document a =
    { name : String
    , fields : a
    , createTime : String
    , updateTime : String
    }


documentDecoder : Decode.Decoder a -> Decode.Decoder (Document a)
documentDecoder fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" fieldDecoder
        |> Pipeline.required "createTime" Decode.string
        |> Pipeline.required "updateTime" Decode.string


transactionResolver : Decode.Decoder String
transactionResolver =
    Decode.field "transaction" Decode.string


type alias Commit =
    { commitTime : String }


commitResolver : Decode.Decoder Commit
commitResolver =
    Decode.succeed Commit
        |> Pipeline.required "commitTime" Decode.string


type alias Error =
    { code : ErrorInfo
    }


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.succeed Error
        |> Pipeline.required "error" errorInfoDecoder


type alias ErrorInfo =
    { code : Int
    , message : String
    , status : String
    }


errorInfoDecoder : Decode.Decoder ErrorInfo
errorInfoDecoder =
    Decode.succeed ErrorInfo
        |> Pipeline.required "code" Decode.int
        |> Pipeline.required "message" Decode.string
        |> Pipeline.required "status" Decode.string
