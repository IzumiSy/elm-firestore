module Firestore exposing
    ( Firestore
    , init, withConfig
    , Path, root, collection, subCollection, document
    , Document, Documents, Name, id, get, list, create, insert, upsert, patch, delete, deleteExisting
    , Query, runQuery
    , Error(..), FirestoreError
    , Transaction, TransactionId, CommitTime, begin, commit, getTx, listTx, runQueryTx, updateTx, deleteTx
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore


# Constructors

@docs init, withConfig


# Path

@docs Path, root, collection, subCollection, document


# CRUDs

@docs Document, Documents, Name, id, get, list, create, insert, upsert, patch, delete, deleteExisting


# Query

@docs Query, runQuery


# Error

@docs Error, FirestoreError


# Transaction

@docs Transaction, TransactionId, CommitTime, begin, commit, getTx, listTx, runQueryTx, updateTx, deleteTx

-}

import Dict
import Firestore.Config as Config
import Firestore.Decode as FSDecode
import Firestore.Encode as FSEncode
import Firestore.Internals as Internals
import Firestore.Internals.Path as InternalPath
import Firestore.Options.List as ListOptions
import Firestore.Options.Patch as PatchOptions
import Firestore.Query as Query
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Set
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


{-| A path type

    firestore
        |> Firestore.root
        |> Firestore.collection "users"
        |> Firestore.document "user0"
        |> Firestore.subCollection "tags"
        |> Firestore.list tagDecoder ListOptions.default
        |> Task.attempt GotUserItemTags

-}
type Path pathType
    = Path InternalPath.Path Firestore


type Specified
    = Specified


type alias RootType =
    { collectionPath : Specified
    , queriablePath : Specified
    }


type alias CollectionType =
    { collectionPath : Specified }


type alias DocumentType =
    { documentPath : Specified
    , queriablePath : Specified
    }


{-| A root path
-}
root : Firestore -> Path RootType
root (Firestore config) =
    Path InternalPath.new (Firestore config)


{-| A collection path
-}
collection : String -> Path RootType -> Path CollectionType
collection value (Path current firestore) =
    Path (InternalPath.addCollection value current) firestore


{-| A document path
-}
document : String -> Path CollectionType -> Path DocumentType
document value (Path current firestore) =
    Path (InternalPath.addDocument value current) firestore


{-| A sub-collection path
-}
subCollection : String -> Path DocumentType -> Path CollectionType
subCollection value (Path current firestore) =
    Path (InternalPath.addCollection value current) firestore



-- CRUDs


{-| A path filter for documents
-}
type alias DocumentPath a =
    { a | documentPath : Specified }


{-| A path filter for collections
-}
type alias CollectionPath a =
    { a | collectionPath : Specified }


{-| A pat filter for queriable documents
-}
type alias QueriablePath a =
    { a | queriablePath : Specified }


{-| A record structure for a document fetched from Firestore.
-}
type alias Document a =
    { name : Name
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


{-| Gets a single document.
-}
get : FSDecode.Decoder a -> Path (DocumentPath b) -> Task.Task Error (Document a)
get =
    getInternal []


{-| A record structure composed of multiple documents fetched from Firestore.
-}
type alias Documents a =
    { documents : List (Document a)
    , nextPageToken : Maybe ListOptions.PageToken
    }


{-| Lists documents.
-}
list : FSDecode.Decoder a -> ListOptions.Options -> Path (CollectionPath b) -> Task.Task Error (Documents a)
list =
    listInternal []


{-| Insert a document into a collection.

The document will get a fresh document id.

-}
insert : FSDecode.Decoder a -> FSEncode.Encoder -> Path (CollectionPath b) -> Task.Task Error (Document a)
insert fieldDecoder encoder (Path path_ (Firestore config)) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] (Config.Path path_) config
        , body = Http.jsonBody <| documentEncoder encoder
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeOne Name
                |> jsonResolver
        }


{-| Creates a document with a given document id.

Takes the document id as the first argument.

-}
create :
    FSDecode.Decoder a
    -> { id : String, document : FSEncode.Encoder }
    -> Path (CollectionPath b)
    -> Task.Task Error (Document a)
create fieldDecoder params (Path path_ (Firestore config)) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [ UrlBuilder.string "documentId" params.id ] (Config.Path path_) config
        , body = Http.jsonBody <| documentEncoder params.document
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeOne Name
                |> jsonResolver
        }


{-| Updates an existing document.

Creates one if not present.

-}
upsert : FSDecode.Decoder a -> FSEncode.Encoder -> Path (DocumentPath b) -> Task.Task Error (Document a)
upsert fieldDecoder encoder (Path path_ (Firestore config)) =
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] (Config.Path path_) config
        , body = Http.jsonBody <| documentEncoder encoder
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeOne Name
                |> jsonResolver
        }


{-| Updates only specific fields.

If the fields do not exists, they will be created.

-}
patch : FSDecode.Decoder a -> PatchOptions.Options -> Path (DocumentPath b) -> Task.Task Error (Document a)
patch fieldDecoder options (Path path_ (Firestore config)) =
    let
        ( params, fields ) =
            PatchOptions.queryParameters options
    in
    Http.task
        { method = "PATCH"
        , headers = Config.httpHeader config
        , url = Config.endpoint params (Config.Path path_) config
        , body = Http.jsonBody <| documentEncoder <| FSEncode.document fields
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeOne Name
                |> jsonResolver
        }


{-| Deletes a document.

Will succeed if document does not exist.

-}
delete : Path (DocumentPath a) -> Task.Task Error ()
delete (Path path_ (Firestore config)) =
    Http.task
        { method = "DELETE"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] (Config.Path path_) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = emptyResolver
        }


{-| Deletes a document.

Will fail if document does not exist.

-}
deleteExisting : Path (DocumentPath a) -> Task.Task Error ()
deleteExisting (Path path_ (Firestore config)) =
    Http.task
        { method = "DELETE"
        , headers = Config.httpHeader config
        , url =
            Config.endpoint
                [ UrlBuilder.string "currentDocument.exists" "true" ]
                (Config.Path path_)
                config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = emptyResolver
        }


{-| A record structure for query operation result
-}
type alias Query a =
    { transaction : Maybe TransactionId
    , document : Document a
    , readTime : Time.Posix
    , skippedResults : Int
    }


{-| Runs a query operation

This opeartion only accepts a path built with `root` or `document`.

-}
runQuery : FSDecode.Decoder a -> Query.Query -> Path (QueriablePath b) -> Task.Task Error (List (Query a))
runQuery =
    runQueryInternal Nothing



-- Name


{-| Name field of Firestore document
-}
type Name
    = Name Internals.Name


{-| Extracts ID from Name field
-}
id : Name -> String
id (Name (Internals.Name value _)) =
    value



-- Transaction


{-| Transaction ID
-}
type TransactionId
    = TransactionId String


{-| Data type for Transaction
-}
type
    Transaction
    -- Implementation of Transaction type has Dict for updation and Set for deletion.
    -- Firebase RESTful API requires to send update/delete mutations seperately on commit as commitEncoder shows
    -- So I feel that it is way easier to have them at once on type definition than putting both into List, Dict,
    -- or something and then splitting them into to each at runtime...
    = Transaction TransactionId (Dict.Dict String FSEncode.Encoder) (Set.Set String)


{-| Gets a single document in transaction
-}
getTx : Transaction -> FSDecode.Decoder a -> Path (DocumentPath b) -> Task.Task Error (Document a)
getTx (Transaction (TransactionId tId) _ _) =
    getInternal [ UrlBuilder.string "transaction" tId ]


{-| Lists documents in transaction
-}
listTx : Transaction -> FSDecode.Decoder a -> ListOptions.Options -> Path (CollectionPath b) -> Task.Task Error (Documents a)
listTx (Transaction (TransactionId tId) _ _) =
    listInternal [ UrlBuilder.string "transaction" tId ]


{-| Runs a query operation in transaction

This works as almost the same as `runQuery` function, but the difference is that this function accepts transaction.

-}
runQueryTx : Transaction -> FSDecode.Decoder a -> Query.Query -> Path (QueriablePath b) -> Task.Task Error (List (Query a))
runQueryTx =
    runQueryInternal << Just


{-| Adds update into the transaction
-}
updateTx : Path (DocumentPath a) -> FSEncode.Encoder -> Transaction -> Transaction
updateTx path encoder (Transaction tId encoders deletes) =
    Transaction tId (Dict.insert (InternalPath.toString path) encoder encoders) deletes


{-| Adds deletion into the transaction
-}
deleteTx : Path (DocumentPath a) -> Transaction -> Transaction
deleteTx path (Transaction tId encoders deletes) =
    Transaction tId encoders (Set.insert (InternalPath.toString path) deletes)


{-| Starts a new transaction.
-}
begin : Firestore -> Task.Task Error Transaction
begin (Firestore config) =
    Task.map (\transaction -> Transaction transaction Dict.empty Set.empty) <|
        Http.task
            { method = "POST"
            , headers = Config.httpHeader config
            , url = Config.endpoint [] (Config.Op "beginTransaction") config
            , body = Http.jsonBody beginEncoder
            , timeout = Nothing
            , resolver = jsonResolver transactionDecoder
            }


{-| A time transaction commited at
-}
type alias CommitTime =
    Time.Posix


{-| Commits a transaction, while optionally updating and deleting documents.

Only `readWrite` transaction is currently supported which requires authorization that can be set via `Config.withAuthorization` function.
Transaction in Firetore works in a pattern of "unit of work". It requires sets of updates and deletes to be commited.

    model.firestore
        |> Firestore.commit
            (transaction
                |> Firestore.updateTx "users/user1" newUser1
                |> Firestore.updateTx "users/user2" newUser2
                |> Firestore.deleteTx "users/user3"
                |> Firestore.deleteTx "users/user4"
            )
        |> Task.attempt Commited

-}
commit : Transaction -> Firestore -> Task.Task Error CommitTime
commit transaction (Firestore config) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] (Config.Op "commit") config
        , body = Http.jsonBody <| commitEncoder config transaction
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


transactionDecoder : Decode.Decoder TransactionId
transactionDecoder =
    Decode.field "transaction" (Decode.map TransactionId Decode.string)


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


documentEncoder : FSEncode.Encoder -> Encode.Value
documentEncoder encoder =
    Encode.object
        [ ( "fields", FSEncode.encode encoder )
        ]


commitDocumentEncoder : String -> FSEncode.Encoder -> Encode.Value
commitDocumentEncoder name encoder =
    Encode.object
        [ ( "name", Encode.string name )
        , ( "fields", FSEncode.encode encoder )
        ]


commitEncoder : Config.Config -> Transaction -> Encode.Value
commitEncoder config (Transaction (TransactionId tId) updates deletes) =
    let
        withBasePath name =
            UrlBuilder.relative [ Config.basePath config, name ] []

        deletes_ =
            deletes
                |> Set.toList
                |> List.map
                    (\name ->
                        ( "delete"
                        , Encode.string <| withBasePath name
                        )
                    )

        updates_ =
            updates
                |> Dict.toList
                |> List.map
                    (\( name, document_ ) ->
                        ( "update"
                        , commitDocumentEncoder (withBasePath name) document_
                        )
                    )
    in
    Encode.object
        [ ( "transaction", Encode.string tId )
        , ( "writes"
          , Encode.list
                (Encode.object << List.singleton)
                (deletes_ ++ updates_)
          )
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


getInternal : List UrlBuilder.QueryParameter -> FSDecode.Decoder a -> Path (DocumentPath b) -> Task.Task Error (Document a)
getInternal params fieldDecoder (Path path_ (Firestore config)) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint params (Config.Path path_) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeOne Name
                |> jsonResolver
        }


listInternal : List UrlBuilder.QueryParameter -> FSDecode.Decoder a -> ListOptions.Options -> Path (CollectionPath b) -> Task.Task Error (Documents a)
listInternal params fieldDecoder options (Path path_ (Firestore config)) =
    Http.task
        { method = "GET"
        , headers = Config.httpHeader config
        , url = Config.endpoint (ListOptions.queryParameters options ++ params) (Config.Path path_) config
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeList Name (Internals.PageToken >> ListOptions.PageToken)
                |> jsonResolver
        }


runQueryInternal : Maybe Transaction -> FSDecode.Decoder a -> Query.Query -> Path (QueriablePath b) -> Task.Task Error (List (Query a))
runQueryInternal maybeTransaction fieldDecoder query (Path path_ (Firestore config)) =
    Http.task
        { method = "POST"
        , headers = Config.httpHeader config
        , url = Config.endpoint [] (Config.PathOp path_ "runQuery") config
        , body =
            Http.jsonBody <|
                Encode.object <|
                    List.filterMap identity <|
                        [ Just ( "structuredQuery", Query.encode query )
                        , Maybe.map
                            (\(Transaction (TransactionId tId) _ _) -> ( "transaction", Encode.string tId ))
                            maybeTransaction
                        ]
        , timeout = Nothing
        , resolver =
            fieldDecoder
                |> Internals.decodeQueries Name TransactionId
                |> jsonResolver
        }


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
