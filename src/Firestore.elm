module Firestore exposing
    ( Firestore
    , configure, collection, database, authorization
    , get, patch, delete, begin, commit, create
    , Response, Error, ErrorInfo
    , responseDecoder
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore

@docs configure, collection, database, authorization

@docs get, patch, delete, begin, commit, create

@docs Response, Error, ErrorInfo

@docs Transaction

-}

import Firestore.Config.APIKey as APIKey exposing (APIKey)
import Firestore.Config.Authorization as Authorization exposing (Authorization)
import Firestore.Config.ProjectId as ProjectId exposing (ProjectId)
import Firestore.Document as Document
import Firestore.Document.Fields as Fields
import Firestore.Path as Path exposing (Path)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import String.Interpolate as Interpolate
import Task
import Time


type Firestore
    = Firestore APIKey ProjectId DatabaseId Path Authorization


{-| Config record has all information which is required to send requests to Firestore through REST API
-}
type alias Config =
    { apiKey : APIKey
    , projectId : ProjectId
    }


{-| Builds a new Firestore connection with Config
-}
configure : Config -> Firestore
configure { apiKey, projectId } =
    Firestore apiKey projectId defaultDatabase Path.empty Authorization.empty


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
collection pathValue (Firestore apiKey projectId databaseId path auth) =
    Firestore apiKey projectId databaseId (Path.append pathValue path auth)


{-| Specifies database id to connecto to.
-}
database : String -> Firestore -> Firestore
database value (Firestore apiKey projectId _ path authorization) =
    Firestore apiKey projectId (DatabaseId value) path auth


{-| Specifies authorization header
-}
authorization : Authorization -> Firesbase -> Firebase
authorization auth (Firestore apiKey projectId databaseId path _) =
    Firebase apiKey projectId databaseId path auth



-- Request


{-| Gets a single document.
-}
get : Decode.Decoder a -> Firestore -> Task.Task Http.Error (Response a)
get fieldDecoder (Firestore apiKey projectId (DatabaseId databaseId) path auth) =
    Http.task
        { method = "GET"
        , headers =
            auth
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


{-| Creates a new document.
-}
create : Fields.Fields -> Decode.Decoder a -> Firestore -> Task.Task Http.Error (Response a)
create fields fieldDecoder (Firestore apiKey projectId (DatabaseId databaseId) path auth) =
    Http.task
        { method = "POST"
        , headers =
            auth
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.jsonBody <| Document.encode fields
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


{-| Updates or inserts a document.
-}
patch : Fields.Fields -> Decode.Decoder a -> Firestore -> Task.Task Http.Error (Response a)
patch fields fieldDecoder (Firestore apiKey projectId (DatabaseId databaseId) path auth) =
    Http.task
        { method = "PATCH"
        , headers =
            auth
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.jsonBody <| Document.encode fields
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


{-| Deletes a document.
-}
delete : Firestore -> Task.Task Http.Error ()
delete (Firestore apiKey projectId (DatabaseId databaseId) path auth) =
    Http.task
        { method = "GET"
        , headers =
            auth
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = emptyResolver
        }


{-| Starts a new transaction.
-}
begin : Firestore -> Task.Task Http.Error Transaction
begin (Firestore apiKey projectId (DatabaesId databaseId) _ auth) =
    Task.map Transaction <|
        Http.task
            { method = "POST"
            , headers =
                auth
                    |> Maybe.map List.singleton
                    |> Maybe.withDefault []
            , url =
                Interpolate.interpolate
                    "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents:beginTransaction?key={2}"
                    [ ProjectId.unwrap projectId
                    , databaseId
                    , APIKey.unwrap apiKey
                    ]
            , body = Http.emptyBody
            , timeout = Nothing
            , resolver = jsonResolver transactionResolver
            }


{-| Commits a transaction, while optionally updating documents.
-}
commit : Decode.Value -> Firestore -> Task.Task Http.Error Commit
commit body (Firestore apiKey projectId (DatabaseId databaseId) _ auth) =
    Http.task
        { method = "POST"
        , headers =
            auth
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents:commit?key={2}"
                [ ProjectId.unwrap projectId
                , databaseId
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

                Http.GoodStatus_ _ body ->
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


type alias Response a =
    { documents : List (Document.Document a) }


responseDecoder : Decode.Decoder a -> Decode.Decoder (Response a)
responseDecoder fieldDecoder =
    Decode.succeed Response
        |> Pipeline.required "documents" (fieldDecoder |> Document.decoder |> Decode.list)


transactionResolver : Decode.Decoder String
transactionResolver =
    Decode.field "transaction" Decode.string


type alias Commit =
    { commitTime : Time.Posix }


commitResolver : Decode.Decoder Commit
commitResolver =
    Decode.succeed Commit
        |> Pipeline.required "commitTime" Iso8601.decoder


type alias Error =
    { code : ErrorInfo }


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



-- Database


type DatabaseId
    = DatabaseId String


defaultDatabase : DatabaseId
defaultDatabase =
    DatabaseId "(default)"



-- Transaction


type Transaction
    = Transaction String
