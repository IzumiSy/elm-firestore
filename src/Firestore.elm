module Firestore exposing
    ( Firestore, init
    , withCollection, withDatabase, withAuthorization
    , get, patch, delete, begin, commit, create
    , Response, Error(..), FirestoreError
    , errorDecoder, responseDecoder
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore, init

@docs withCollection, withDatabase, withAuthorization

@docs get, patch, delete, begin, commit, create

@docs Response, Error, FirestoreError

@docs Transaction

-}

import Firestore.Config.APIKey as APIKey exposing (APIKey)
import Firestore.Config.Authorization as Authorization exposing (Authorization)
import Firestore.Config.Database as Database
import Firestore.Config.Project as Project
import Firestore.Document as Document
import Firestore.Path as Path exposing (Path)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Task
import Template exposing (render, template, withString, withValue)
import Time


type Firestore
    = Firestore
        { apiKey : APIKey
        , project : Project.Project
        , database : Database.Database
        , path : Path
        , authorization : Authorization
        }


{-| Config record has all information which is required to send requests to Firestore through REST API
-}
type alias Config =
    { apiKey : APIKey
    , project : Project.Project
    }


{-| Builds a new Firestore connection with Config
-}
init : Config -> Firestore
init { apiKey, project } =
    Firestore
        { apiKey = apiKey
        , project = project
        , database = Database.default
        , path = Path.empty
        , authorization = Authorization.empty
        }


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
withCollection : String -> Firestore -> Firestore
withCollection value (Firestore payload) =
    Firestore { payload | path = Path.append value payload.path }


{-| Specifies database id to connecto to.
-}
withDatabase : Database.Database -> Firestore -> Firestore
withDatabase value (Firestore payload) =
    Firestore { payload | database = value }


{-| Specifies authorization header
-}
withAuthorization : Authorization -> Firestore -> Firestore
withAuthorization value (Firestore payload) =
    Firestore { payload | authorization = value }



-- CRUDs


{-| Gets a single document.
-}
get : Decode.Decoder a -> Firestore -> Task.Task Error (Response a)
get fieldDecoder ((Firestore { authorization }) as firestore) =
    Http.task
        { method = "GET"
        , headers =
            authorization
                |> Authorization.header
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url = buildUrl firestore
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


{-| Creates a new document.
-}
create : Document.Fields -> Decode.Decoder a -> Firestore -> Task.Task Error (Response a)
create fields fieldDecoder ((Firestore { authorization }) as firestore) =
    Http.task
        { method = "POST"
        , headers =
            authorization
                |> Authorization.header
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url = buildUrl firestore
        , body = Http.jsonBody <| Document.encode fields
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


{-| Updates or inserts a document.
-}
patch : Document.Fields -> Decode.Decoder a -> Firestore -> Task.Task Error (Response a)
patch fields fieldDecoder ((Firestore { authorization }) as firestore) =
    Http.task
        { method = "PATCH"
        , headers =
            authorization
                |> Authorization.header
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url = buildUrl firestore
        , body = Http.jsonBody <| Document.encode fields
        , timeout = Nothing
        , resolver = jsonResolver (responseDecoder fieldDecoder)
        }


{-| Deletes a document.
-}
delete : Firestore -> Task.Task Error ()
delete ((Firestore { authorization }) as firestore) =
    Http.task
        { method = "GET"
        , headers =
            authorization
                |> Authorization.header
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url = buildUrl firestore
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = emptyResolver
        }



-- Transaction


type Transaction
    = Transaction String


{-| Starts a new transaction.
-}
begin : Firestore -> Task.Task Error Transaction
begin (Firestore payload) =
    Task.map Transaction <|
        Http.task
            { method = "POST"
            , headers =
                payload.authorization
                    |> Authorization.header
                    |> Maybe.map List.singleton
                    |> Maybe.withDefault []
            , url =
                template "https://firestore.googleapis.com/v1beta1/projects/"
                    |> withValue (Project.toString << .project)
                    |> withString "/databases/"
                    |> withValue (Database.toString << .database)
                    |> withString "/documents:beginTransaction?key="
                    |> withValue (APIKey.unwrap << .apiKey)
                    |> render payload
            , body = Http.emptyBody
            , timeout = Nothing
            , resolver = jsonResolver transactionResolver
            }


{-| Commits a transaction, while optionally updating documents.
-}
commit : Decode.Value -> Firestore -> Task.Task Error CommitTime
commit body (Firestore payload) =
    Http.task
        { method = "POST"
        , headers =
            payload.authorization
                |> Authorization.header
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
        , url =
            template "https://firestore.googleapis.com/v1beta1/projects/"
                |> withValue (Project.toString << .project)
                |> withString "/databases/"
                |> withValue (Database.toString << .database)
                |> withString "/documents:commit?key="
                |> withValue (APIKey.unwrap << .apiKey)
                |> render payload
        , body = Http.jsonBody body
        , timeout = Nothing
        , resolver = jsonResolver commitResolver
        }



-- Resolver


jsonResolver : Decode.Decoder a -> Http.Resolver Error a
jsonResolver decoder =
    Http.stringResolver <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err <| Http_ <| Http.BadUrl url

                Http.Timeout_ ->
                    Err <| Http_ Http.Timeout

                Http.NetworkError_ ->
                    Err <| Http_ Http.NetworkError

                Http.BadStatus_ { statusCode } body ->
                    case Decode.decodeString errorDecoder body of
                        Err _ ->
                            Err <| Http_ <| Http.BadStatus statusCode

                        Ok firestoreError ->
                            Err firestoreError

                Http.GoodStatus_ _ body ->
                    case Decode.decodeString decoder body of
                        Err _ ->
                            Err <| Http_ <| Http.BadBody body

                        Ok result ->
                            Ok result


emptyResolver : Http.Resolver Error ()
emptyResolver =
    Http.stringResolver <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err <| Http_ <| Http.BadUrl url

                Http.Timeout_ ->
                    Err <| Http_ Http.Timeout

                Http.NetworkError_ ->
                    Err <| Http_ Http.NetworkError

                Http.BadStatus_ metadata _ ->
                    Err <| Http_ <| Http.BadStatus metadata.statusCode

                Http.GoodStatus_ _ _ ->
                    Ok ()



-- Decoder


type alias Response a =
    List (Document.Document a)


responseDecoder : Decode.Decoder a -> Decode.Decoder (Response a)
responseDecoder fieldDecoder =
    Decode.succeed identity
        |> Pipeline.required "documents" (fieldDecoder |> Document.decode |> Decode.list)


transactionResolver : Decode.Decoder String
transactionResolver =
    Decode.field "transaction" Decode.string


type alias CommitTime =
    Time.Posix


commitResolver : Decode.Decoder CommitTime
commitResolver =
    Decode.succeed identity
        |> Pipeline.required "commitTime" Iso8601.decoder


type Error
    = Http_ Http.Error
    | Response FirestoreError


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.succeed Response
        |> Pipeline.required "error" errorInfoDecoder


type alias FirestoreError =
    { code : Int
    , message : String
    , status : String
    }


errorInfoDecoder : Decode.Decoder FirestoreError
errorInfoDecoder =
    Decode.succeed FirestoreError
        |> Pipeline.required "code" Decode.int
        |> Pipeline.required "message" Decode.string
        |> Pipeline.required "status" Decode.string



-- Internals


{-| Utility function to build URL for CRUD operation.
-}
buildUrl : Firestore -> String
buildUrl (Firestore payload) =
    template "https://firestore.googleapis.com/v1beta1/projects/"
        |> withValue (Project.toString << .project)
        |> withString "/databases/"
        |> withValue (Database.toString << .database)
        |> withString "/documents/"
        |> withValue (Path.toString << .path)
        |> withString "?key="
        |> withValue (APIKey.unwrap << .apiKey)
        |> render payload
