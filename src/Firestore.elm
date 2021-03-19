module Firestore exposing
    ( Firestore
    , init, withConfig
    , Path, path
    , Document, get, PageToken, Documents, ListOption, list, create, insert, upsert, patch, delete, deleteExisting
    , Error(..), FirestoreError
    , Transaction, CommitTime, begin, update, commit
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore, Collection


# Constructors

@docs init, withConfig


# Path

@docs Path, path


# CRUDs

@docs Document, get, PageToken, Documents, ListOption, list, create, insert, upsert, patch, delete, deleteExisting


# Error

@docs Error, FirestoreError


# Transaction

@docs Transaction, CommitTime, begin, update, commit

-}

import Firestore.Config as Config
import Firestore.Decode as FSDecode
import Firestore.Encode as FSEncode
import Firestore.Internals.Document as Document
import Firestore.Internals.PageToken as InternalPageToken
import Firestore.Options.List as ListOptions
import Firestore.Options.Patch as PatchOptions
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Task
import Time
import Url.Builder as UrlBuilder


{-| Data type for Firestore.
-}
type Firestore
    = Firestore Config.Config


{-| Builds a new Firestore connection with Config.
-}
init : Config.Config -> Firestore
init config =
    Firestore config


{-| Updates configuration.
-}
withConfig : Config.Config -> Firestore -> Firestore
withConfig config (Firestore _) =
    Firestore config


{-| Type to point document path to operate.

A `Path` value is always required in calling CRUD operations.
This interface design enforces users to call `path` function to build `Path` value beforehand in order to prevent forgetting specifiying path to operate.

-}
type Path
    = Path String Firestore


{-| Specifies document path.

    firestore
        |> Firestore.path "users/items/tags"
        |> Firestore.get tagsDecoder
        |> Task.attempt GotUserItemTags

-}
path : String -> Firestore -> Path
path value (Firestore config) =
    Path value (Firestore config)



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
get : FSDecode.Decoder a -> Path -> Task.Task Error (Document a)
get fieldDecoder (Path path_ (Firestore config)) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path_ config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| The next page token.

This token is required in fetching the next page offset by `pageSize` in `list` operation.

-}
type PageToken
    = PageToken InternalPageToken.PageToken


{-| A record structure composed of multiple documents fetched from Firestore.
-}
type alias Documents a =
    { documents : List (Document a)
    , nextPageToken : Maybe PageToken
    }


{-| Data structure for query parameter in calling `list` operation.
-}
type alias ListOption =
    { pageSize : Int
    , orderBy : String
    , pageToken : Maybe PageToken
    }


{-| Lists documents.
-}
list :
    FSDecode.Decoder a
    -> ListOptions.Options
    -> Path
    -> Task.Task Error (Documents a)
list fieldDecoder options (Path path_ (Firestore config)) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (ListOptions.queryParameters options) path_ config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeList (InternalPageToken.new >> PageToken)
                |> jsonResolver
        }


{-| Insert a document into a collection.

The document will get a fresh document id.

-}
insert : FSDecode.Decoder a -> FSEncode.Encoder -> Path -> Task.Task Error (Document a)
insert fieldDecoder encoder (Path path_ (Firestore config)) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path_ config
        , body = Http.jsonBody <| FSEncode.encode encoder
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Creates a document with a given document id.

Takes the document id as the first argument.

-}
create :
    FSDecode.Decoder a
    -> { id : String, document : FSEncode.Encoder }
    -> Path
    -> Task.Task Error (Document a)
create fieldDecoder { id, document } (Path path_ (Firestore config)) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url =
            Config.endpoint
                [ UrlBuilder.string "documentId" id ]
                path_
                config
        , body = Http.jsonBody <| FSEncode.encode document
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Updates an existing document.

Creates one if not present.

-}
upsert : FSDecode.Decoder a -> FSEncode.Encoder -> Path -> Task.Task Error (Document a)
upsert fieldDecoder encoder (Path path_ (Firestore config)) =
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path_ config
        , body = Http.jsonBody <| FSEncode.encode encoder
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Updates only specific fields.

If the fields do not exists, they will be created.

-}
patch :
    FSDecode.Decoder a
    -> PatchOptions.Options
    -> Path
    -> Task.Task Error (Document a)
patch fieldDecoder options (Path path_ (Firestore config)) =
    let
        ( params, fields ) =
            PatchOptions.queryParameters options
    in
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url =
            Config.endpoint params path_ config
        , body = Http.jsonBody <| FSEncode.encode <| FSEncode.document fields
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Deletes a document.

Will succeed if document does not exist.

-}
delete : Path -> Task.Task Error ()
delete (Path path_ (Firestore config)) =
    Http.task
        { method = "DELETE"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path_ config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = emptyResolver
        }


{-| Deletes a document.

Will fail if document does not exist.

-}
deleteExisting : Path -> Task.Task Error ()
deleteExisting (Path path_ (Firestore config)) =
    Http.task
        { method = "DELETE"
        , headers = Config.httpHeader config
        , url = Config.endpoint [ UrlBuilder.string "currentDocument.exists" "true" ] path_ config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = emptyResolver
        }



-- Transaction


{-| Data type for Transaction
-}
type Transaction
    = Transaction String (List FSEncode.Encoder)


{-| Adds a new update into the transaction

    model.firestore
        |> Firestore.commit
            (transaction
                |> Firestore.update draft1
                |> Firestore.update draft2
                |> Firestore.update draft3
            )
        |> Task.attempt Commited

-}
update : FSEncode.Encoder -> Transaction -> Transaction
update encoder (Transaction id encoders) =
    Transaction id (encoder :: encoders)


{-| Starts a new transaction.
-}
begin : Firestore -> Task.Task Error Transaction
begin (Firestore config) =
    Task.map (\transaction -> Transaction transaction []) <|
        Http.task
            { method = "POST"
            , headers = Config.httpHeader config
            , url = Config.endpoint [] ":beginTransaction" config
            , body = Http.jsonBody beginEncoder
            , timeout = Nothing
            , resolver = jsonResolver transactionDecoder
            }


{-| A time transaction commited at
-}
type alias CommitTime =
    Time.Posix


{-| Commits a transaction, while optionally updating documents.

Only `readWrite` transaction is currently supported which requires authorization that can be set via `Config.withAuthorization` function.

-}
commit : Transaction -> Firestore -> Task.Task Error CommitTime
commit transaction (Firestore config) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] ":commit" config
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
        , ( "writes", Encode.list FSEncode.encode drafts )
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
