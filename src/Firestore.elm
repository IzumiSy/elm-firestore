module Firestore exposing
    ( Firestore, init
    , withCollection, withConfig
    , Document, get, list, Draft, draft, create, patch, delete
    , Error(..), FirestoreError
    , Transaction, CommitTime, begin, commit, update
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore, init

@docs withCollection, withConfig


# CRUDs

@docs Document, get, list, Draft, draft, create, patch, delete


# Error

@docs Error, FirestoreError


# Transaction

@docs Transaction, CommitTime, begin, commit, update

-}

import Firestore.Config as Config
import Firestore.Internals.Document as Document
import Firestore.Internals.Draft as Draft
import Firestore.Internals.Field as Field
import Firestore.Internals.Path as Path exposing (Path)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Task
import Time


{-| Data type for Firestore
-}
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


{-| A record structure for a document fetched from Firestore.
-}
type alias Document a =
    { name : String
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


{-| Gets a single document.
-}
get : Decode.Decoder a -> Firestore -> Task.Task Error (Document a)
get fieldDecoder (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| Lists documents.
-}
list : Decode.Decoder a -> Firestore -> Task.Task Error (List (Document a))
list fieldDecoder (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeList fieldDecoder
        }


{-| A type for a document before persisted on Firestore.
-}
type Draft
    = Draft Draft.Draft


{-| Creates a new document for `create` or `patch`.
-}
draft : List ( String, Field.Field ) -> Draft
draft =
    Draft << Draft.new


{-| Creates a new document.
-}
create : Decode.Decoder a -> Draft -> Firestore -> Task.Task Error (Document a)
create fieldDecoder (Draft draft_) (Firestore config path) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.jsonBody <| Draft.encode draft_
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| Updates or inserts a document.
-}
patch : Decode.Decoder a -> Draft -> Firestore -> Task.Task Error (Document a)
patch fieldDecoder (Draft draft_) (Firestore config path) =
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url = Config.endpoint (Path.toString path) config
        , body = Http.jsonBody <| Draft.encode draft_
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


{-| Data type for Transaction
-}
type Transaction
    = Transaction String (List Draft)


{-| Adds a new update into the transaction
-}
update : Draft -> Transaction -> Transaction
update draft_ (Transaction id drafts) =
    Transaction id (draft_ :: drafts)


{-| Starts a new transaction.
-}
begin : Firestore -> Task.Task Error Transaction
begin (Firestore config _) =
    Task.map (\transaction -> Transaction transaction []) <|
        Http.task
            { method = "POST"
            , headers = Config.httpHeader config
            , url = Config.endpoint ":beginTransaction" config
            , body = Http.jsonBody beginEncoder
            , timeout = Nothing
            , resolver = jsonResolver transactionDecoder
            }


{-| A time transaction commited at
-}
type alias CommitTime =
    Time.Posix


{-| Commits a transaction, while optionally updating documents.

Only `readWrite` transaction is supported.

-}
commit : Transaction -> Firestore -> Task.Task Error CommitTime
commit transaction (Firestore config _) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint ":commit" config
        , body = Http.jsonBody <| commitEncoder transaction
        , timeout = Nothing
        , resolver = jsonResolver commitDecoder
        }



-- Error


{-| An error type

This type is available in order to disregard type of errors between protocol related errors as Http\_ or backend related errors as Response.

-}
type Error
    = Http_ Http.Error
    | Response FirestoreError


{-| Data structure for errors from Firestore
-}
type alias FirestoreError =
    { code : Int
    , message : String
    , status : String
    }



-- Decoders


transactionDecoder : Decode.Decoder String
transactionDecoder =
    Decode.field "transaction" Decode.string


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



-- Encoders


commitEncoder : Transaction -> Encode.Value
commitEncoder (Transaction transaction drafts) =
    Encode.object
        [ ( "transaction", Encode.string transaction )
        , ( "writes", Encode.list Draft.encode <| List.map (\(Draft draft_) -> draft_) drafts )
        ]


beginEncoder : Encode.Value
beginEncoder =
    Encode.object
        [ ( "options"
          , Encode.object
                [ ( "readWrite"
                  , Encode.object []
                  )
                ]
          )
        ]



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
