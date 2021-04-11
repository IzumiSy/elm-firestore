module Firestore.Internals exposing
    ( Document
    , Documents
    , Name(..)
    , PageToken(..)
    , decodeList
    , decodeOne
    , decodeQuery
    , nameDecoder
    )

import Firestore.Decode as FSDecode
import Firestore.Query exposing (Query)
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import List.Extra as ExList
import Time


type alias Document a b =
    { name : b
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


decodeOne : (Name -> b) -> FSDecode.Decoder a -> Decode.Decoder (Document a b)
decodeOne namer fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" (Decode.map namer nameDecoder)
        |> Pipeline.required "fields" (FSDecode.decode fieldDecoder)
        |> Pipeline.required "createTime" Iso8601.decoder
        |> Pipeline.required "updateTime" Iso8601.decoder


type alias Documents a b t =
    { documents : List (Document a b)
    , nextPageToken : Maybe t
    }


decodeList : (Name -> b) -> (String -> t) -> FSDecode.Decoder a -> Decode.Decoder (Documents a b t)
decodeList namer pageTokener fieldDecoder =
    Decode.succeed Documents
        |> Pipeline.required "documents" (fieldDecoder |> decodeOne namer |> Decode.list)
        |> Pipeline.optional "nextPageToken" (Decode.map (Just << pageTokener) Decode.string) Nothing


type alias Query a b t =
    { transaction : t
    , document : Document a b
    , readTime : Time.Posix
    , skippedResults : Int
    }


decodeQuery : (Name -> b) -> (String -> t) -> FSDecode.Decoder a -> Decode.Decoder (Query a b t)
decodeQuery namer transactioner fieldDecoder =
    Decode.succeed Query
        |> Pipeline.required "transaction" (Decode.map transactioner Decode.string)
        |> Pipeline.required "document" (decodeOne namer fieldDecoder)
        |> Pipeline.required "readTime" Iso8601.decoder
        |> Pipeline.required "skippedResults" Decode.int


{-| Internal implementation of Name field of Document
-}
type Name
    = Name String String


{-| Decoder for Name type

The response coming from Firestore has `name` field which is a path including parent name.
This decoder does splitting slashes in order to extract the ID part from it.

-}
nameDecoder : Decode.Decoder Name
nameDecoder =
    Decode.string
        |> Decode.andThen
            (\value ->
                value
                    |> String.split "/"
                    |> ExList.last
                    |> Maybe.map (\id_ -> Decode.succeed (Name id_ value))
                    |> Maybe.withDefault (Decode.fail "Failed decoding name")
            )


{-| Internal implementation of PageToken
-}
type PageToken
    = PageToken String
