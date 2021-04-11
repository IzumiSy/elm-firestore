module Firestore.Internals exposing
    ( Document
    , Documents
    , PageToken(..)
    , decodeList
    , decodeOne
    , decodeQuery
    )

import Firestore.Decode as FSDecode
import Firestore.Query exposing (Query)
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Time


type alias Document a b =
    { name : b
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


decodeOne : Decode.Decoder b -> FSDecode.Decoder a -> Decode.Decoder (Document a b)
decodeOne nameDecoder fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" nameDecoder
        |> Pipeline.required "fields" (FSDecode.decode fieldDecoder)
        |> Pipeline.required "createTime" Iso8601.decoder
        |> Pipeline.required "updateTime" Iso8601.decoder


type alias Documents a b t =
    { documents : List (Document a b)
    , nextPageToken : Maybe t
    }


decodeList : (String -> t) -> Decode.Decoder b -> FSDecode.Decoder a -> Decode.Decoder (Documents a b t)
decodeList pageTokener nameDecoder fieldDecoder =
    Decode.succeed Documents
        |> Pipeline.required "documents" (fieldDecoder |> decodeOne nameDecoder |> Decode.list)
        |> Pipeline.optional "nextPageToken" (Decode.map (Just << pageTokener) Decode.string) Nothing


type alias Query a b t =
    { transaction : t
    , document : Document a b
    , readTime : Time.Posix
    , skippedResults : Int
    }


decodeQuery : (String -> t) -> Decode.Decoder b -> FSDecode.Decoder a -> Decode.Decoder (Query a b t)
decodeQuery transactioner nameDecoder fieldDecoder =
    Decode.succeed Query
        |> Pipeline.required "transaction" (Decode.map transactioner Decode.string)
        |> Pipeline.required "document" (decodeOne nameDecoder fieldDecoder)
        |> Pipeline.required "readTime" Iso8601.decoder
        |> Pipeline.required "skippedResults" Decode.int


{-| Internal implementation of PageToken
-}
type PageToken
    = PageToken String
