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


type alias Document a =
    { name : String
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


decodeOne : FSDecode.Decoder a -> Decode.Decoder (Document a)
decodeOne fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" (FSDecode.decode fieldDecoder)
        |> Pipeline.required "createTime" Iso8601.decoder
        |> Pipeline.required "updateTime" Iso8601.decoder


type alias Documents a b =
    { documents : List (Document a)
    , nextPageToken : Maybe b
    }


decodeList : (String -> b) -> FSDecode.Decoder a -> Decode.Decoder (Documents a b)
decodeList pageTokener fieldDecoder =
    Decode.succeed Documents
        |> Pipeline.required "documents" (fieldDecoder |> decodeOne |> Decode.list)
        |> Pipeline.optional "nextPageToken" (Decode.map (Just << pageTokener) Decode.string) Nothing


type alias Query a b =
    { transaction : b
    , document : Document a
    , readTime : Time.Posix
    , skippedResults : Int
    }


decodeQuery : (String -> b) -> FSDecode.Decoder a -> Decode.Decoder (Query a b)
decodeQuery transactioner fieldDecoder =
    Decode.succeed Query
        |> Pipeline.required "transaction" (Decode.map transactioner Decode.string)
        |> Pipeline.required "document" (decodeOne fieldDecoder)
        |> Pipeline.required "readTime" Iso8601.decoder
        |> Pipeline.required "skippedResults" Decode.int


{-| Internal implementation of PageToken
-}
type PageToken
    = PageToken String
