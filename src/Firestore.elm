module Firestore exposing
    ( Firestore, init
    , withCollection, withConfig
    , get, list, patch, delete, create
    , Error(..), FirestoreError
    , Transaction, begin, commit
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore, init

@docs withCollection, withConfig


# CRUDs

@docs get, list, patch, delete, create


# Error

@docs Error, FirestoreError


# Transaction

@docs Transaction, begin, commit

-}

import Firestore.Config as Config
import Firestore.Document as Document
import Firestore.Path as Path exposing (Path)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Task
import Time


type Firestore
    = Firestore Config.Config Path


{-| Builds a new Firestore connection with Config
-}
init : Config.Config -> Firestore
init config =
    Firestore config Path.empty


{-| Drills down document paths with a specific path name.
This function is aimed to be chanind with pipeline operators in order to build up document path.

    firestore
        |> Firestore.collection "users"
        |> Firestore.collection "items"
        |> Firestore.collection "tags"
        |> Firestore.get
        |> Task.attempt GotUserItemTags

Of course, you can make it a single string as well

    firestore
        |> Firestore.collection "users/items/tags"
        |> Firestore.get
        |> Task.attempt GotUserItemTags

-}
withCollection : String -> Firestore -> Firestore
withCollection value (Firestore config path) =
    Firestore config (Path.append value path)


{-| Updates configuration
-}
withConfig : Config.Config -> Firestore -> Firestore
withConfig config (Firestore _ path) =
    Firestore config path



-- CRUDs


{-| Gets a single document.
-}
get : Decode.Decoder a -> Firestore -> Task.Task Error (Document.Document a)
get fieldDecoder (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| Lists documents
-}
list : Decode.Decoder a -> Firestore -> Task.Task Error (List (Document.Document a))
list fieldDecoder (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeList fieldDecoder
        }


{-| Creates a new document.
-}
create : Document.Fields -> Decode.Decoder a -> Firestore -> Task.Task Error (Document.Document a)
create fields fieldDecoder (Firestore config path) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.jsonBody <| Document.encode fields
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| Updates or inserts a document.
-}
patch : Document.Fields -> Decode.Decoder a -> Firestore -> Task.Task Error (Document.Document a)
patch fields fieldDecoder (Firestore config path) =
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.jsonBody <| Document.encode fields
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| Deletes a document.
-}
delete : Firestore -> Task.Task Error ()
delete (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
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
begin (Firestore config _) =
    Task.map Transaction <|
        Http.task
            { method = "POST"
            , headers = Config.httpHeader config
            , url = Config.endpoint "/documents:beginTransaction" config
            , body = Http.emptyBody
            , timeout = Nothing
            , resolver = jsonResolver transactionDecoder
            }


{-| Commits a transaction, while optionally updating documents.
-}
commit : Decode.Value -> Firestore -> Task.Task Error CommitTime
commit body (Firestore config _) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint "/documents:commit" config
        , body = Http.jsonBody body
        , timeout = Nothing
        , resolver = jsonResolver commitDecoder
        }



-- Error


type Error
    = Http_ Http.Error
    | Response FirestoreError


type alias FirestoreError =
    { code : Int
    , message : String
    , status : String
    }



-- Decoder


transactionDecoder : Decode.Decoder String
transactionDecoder =
    Decode.field "transaction" Decode.string


type alias CommitTime =
    Time.Posix


commitDecoder : Decode.Decoder CommitTime
commitDecoder =
    Decode.succeed identity
        |> Pipeline.required "commitTime" Iso8601.decoder


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.succeed Response
        |> Pipeline.required "error" errorInfoDecoder


errorInfoDecoder : Decode.Decoder FirestoreError
errorInfoDecoder =
    Decode.succeed FirestoreError
        |> Pipeline.required "code" Decode.int
        |> Pipeline.required "message" Decode.string
        |> Pipeline.required "status" Decode.string



-- Internals


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
