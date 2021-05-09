module Firestore.Internals exposing
    ( Document
    , Documents
    , Name(..)
    , PageToken(..)
    , decodeList
    , decodeOne
    , decodeQueries
    , nameDecoder
    )

import Firestore.Decode as FSDecode
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
        |> Pipeline.optional "nextPageToken" (Decode.map (pageTokener >> Just) Decode.string) Nothing


type QueryResult a b t
    = Item (ItemBody a b t)
    | Meta MetaBody


type alias ItemBody a b t =
    { transaction : Maybe t
    , document : Document a b
    , readTime : Time.Posix
    , skippedResults : Int
    }


type alias MetaBody =
    { readTime : Time.Posix }


decodeQueryResultItem : (Name -> b) -> (String -> t) -> FSDecode.Decoder a -> Decode.Decoder (ItemBody a b t)
decodeQueryResultItem namer transactioner fieldDecoder =
    Decode.succeed ItemBody
        |> Pipeline.optional "transaction" (Decode.map (transactioner >> Just) Decode.string) Nothing
        |> Pipeline.required "document" (decodeOne namer fieldDecoder)
        |> Pipeline.required "readTime" Iso8601.decoder
        |> Pipeline.optional "skippedResults" Decode.int 0


decodeQueryResultMeta : Decode.Decoder MetaBody
decodeQueryResultMeta =
    Decode.succeed MetaBody
        |> Pipeline.required "readTime" Iso8601.decoder


decodeQueries : (Name -> b) -> (String -> t) -> FSDecode.Decoder a -> Decode.Decoder (List (ItemBody a b t))
decodeQueries namer transactioner fieldDecoder =
    [ Decode.map Item <| decodeQueryResultItem namer transactioner fieldDecoder
    , Decode.map Meta decodeQueryResultMeta
    ]
        |> Decode.oneOf
        |> Decode.list
        |> Decode.andThen
            (\results ->
                {- `runQuery` results are always consisted of two types of data structure: what it calls "item" and "meta".
                   "meta" only has `readTime` field that shows the time query operation has been triggered at.
                   "item" has more fields such as `transaction`, `document`, `readTime`, ...

                   Even though the wrong decoder for `documents` are given, this `decodeQueries` does not return any errors,
                   because `Decode.oneOf` function will intentionally make it into `meta` structure.

                   However, normal results always have only ONE or ZERO `meta` strucuture, so here uses it as a clue to know
                   whether the wrong decoders are given or not. If results has two or more `meta` structures,
                   they might be results decoded wrong and must be `item` structure, not `meta`, so it returns `Decode.fail`.
                -}
                case List.partition isQueryResultItem results of
                    ( values, [] ) ->
                        Decode.succeed <| filterOnlyWithItem values

                    ( values, [ _ ] ) ->
                        Decode.succeed <| filterOnlyWithItem values

                    ( [], _ :: _ ) ->
                        Decode.fail "Invalid decoders must have been given"

                    ( _, _ ) ->
                        Decode.fail "Unexpected decoding error"
            )


filterOnlyWithItem : List (QueryResult a b t) -> List (ItemBody a b t)
filterOnlyWithItem =
    List.filterMap
        (\value ->
            case value of
                Item body ->
                    Just body

                Meta _ ->
                    Nothing
        )


isQueryResultItem : QueryResult a b t -> Bool
isQueryResultItem query =
    case query of
        Item _ ->
            True

        Meta _ ->
            False


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
