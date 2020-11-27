module Firestore exposing
    ( Firestore
    , init, withCollection, withConfig
    , Document, get, PageToken, Documents, ListOption, list, insert, create, override, patch, delete
    , Error(..), FirestoreError
    , Transaction, CommitTime, begin, update, commit
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore


# Constructors

@docs init, withCollection, withConfig


# CRUDs

@docs Document, get, PageToken, Documents, ListOption, list, insert, create, override, patch, delete


# Error

@docs Error, FirestoreError


# Transaction

@docs Transaction, CommitTime, begin, update, commit

-}

import Firestore.Config as Config
import Firestore.Decode as FSDecode
import Firestore.Encode as FSEncode
import Firestore.Internals.Document as Document
import Firestore.Internals.Path as Path exposing (Path)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Task
import Time
import Url.Builder as UrlBuilder


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
get : FSDecode.Decoder a -> Firestore -> Task.Task Error (Document a)
get fieldDecoder (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = jsonResolver <| Document.decodeOne fieldDecoder
        }


{-| The next page token.

This token is required in fetching the next page offset by `pageSize` in `list` operation.

-}
type PageToken
    = PageToken String


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
list : ListOption -> FSDecode.Decoder a -> Firestore -> Task.Task Error (Documents a)
list option fieldDecoder (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url =
            Config.endpoint
                [ UrlBuilder.int "pageSize" option.pageSize
                , UrlBuilder.string "orderBy" option.orderBy
                , option.pageToken
                    |> Maybe.map (\(PageToken value) -> value)
                    |> Maybe.withDefault ""
                    |> UrlBuilder.string "pageToken"
                ]
                path
                config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeList PageToken
                |> jsonResolver
        }


{-| Insert a document into a collection. The document will get a fresh document id.
-}
insert : FSDecode.Decoder a -> FSEncode.Encoder -> Firestore -> Task.Task Error (Document a)
insert fieldDecoder encoder (Firestore config path) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path config
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
create : String -> FSDecode.Decoder a -> FSEncode.Encoder -> Firestore -> Task.Task Error (Document a)
create documentId fieldDecoder encoder (Firestore config path) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url =
            Config.endpoint
                [ UrlBuilder.string "documentId" documentId ]
                path
                config
        , body = Http.jsonBody <| FSEncode.encode encoder
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Overrides an existing document. Creates one if not present.
-}
override : FSDecode.Decoder a -> FSEncode.Encoder -> Firestore -> Task.Task Error (Document a)
override fieldDecoder encoder (Firestore config path) =
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path config
        , body = Http.jsonBody <| FSEncode.encode encoder
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Updates only specific fields. If the fields do not exists, they will be created.
-}
patch : FSDecode.Decoder a -> { updateFields : List ( String, FSEncode.Field ), deleteFields : List String } -> Firestore -> Task.Task Error (Document a)
patch fieldDecoder { updateFields, deleteFields } (Firestore config path) =
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url =
            Config.endpoint
                ((updateFields
                    |> List.map (\( fieldPath, _ ) -> UrlBuilder.string "updateMask.fieldPaths" fieldPath)
                 )
                    ++ (deleteFields
                            |> List.map (\fieldPath -> UrlBuilder.string "updateMask.fieldPaths" fieldPath)
                       )
                )
                path
                config
        , body = Http.jsonBody <| FSEncode.encode <| FSEncode.document <| updateFields
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Document.decodeOne
                |> jsonResolver
        }


{-| Deletes a document.
-}
delete : Firestore -> Task.Task Error ()
delete (Firestore config path) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] path config
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
begin (Firestore config _) =
    Task.map (\transaction -> Transaction transaction []) <|
        Http.task
            { method = "POST"
            , headers = Config.httpHeader config
            , url = Config.endpoint [] (Path.append ":beginTransaction" Path.empty) config
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
commit transaction (Firestore config _) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] (Path.append ":commit" Path.empty) config
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
