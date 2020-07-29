module Firestore.Decode exposing
    ( Decoder, decode
    , document, required, optional
    , Field, bool, bytes, int, string, list, dict, maybe, timestamp, geopoint, reference
    )

{-| Decoders for Firestore

@docs Decoder, decode


# Constructors

@docs document, required, optional


# Types

@docs Field, bool, bytes, int, string, list, dict, maybe, timestamp, geopoint, reference

-}

import Dict
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Time


type Decoder a
    = Decoder (Decode.Decoder a)


{-| Generates Json.Decode.Decoder
-}
decode : Decoder a -> Decode.Decoder a
decode (Decoder decoder) =
    decoder



-- Constructors


{-| Creates a new decoder

This function works like `Json.Decode.Pipeline`.

    Firestore.Decode.document Document
        |> Firestore.Decode.required "name" Firestore.Decode.string
        |> Firestore.Decode.required "age" Firestore.Decode.int
        |> Firestore.Decode.optional "canCode" Firestore.Decode.bool False

-}
document : a -> Decoder a
document =
    Decoder << Decode.succeed


required : String -> Field a -> Decoder (a -> b) -> Decoder b
required name (Field fieldDecoder) (Decoder encoder) =
    Decoder <| Pipeline.required name fieldDecoder encoder


optional : String -> Field a -> a -> Decoder (a -> b) -> Decoder b
optional name (Field fieldDecoder) default (Decoder encoder) =
    Decoder <| Pipeline.optional name fieldDecoder default encoder



-- Types


type Field a
    = Field (Decode.Decoder a)


{-| -}
bool : Field Bool
bool =
    Decode.bool
        |> Decode.field "booleanValue"
        |> Field


{-| -}
bytes : Field String
bytes =
    Decode.string
        |> Decode.field "bytesValue"
        |> Field


{-| -}
int : Field Int
int =
    Decode.field "integerValue" Decode.string
        |> Decode.andThen
            (\value ->
                value
                    |> String.toInt
                    |> Maybe.map Decode.succeed
                    |> Maybe.withDefault (Decode.fail "Unconvertable string to int")
            )
        |> Field


{-| -}
string : Field String
string =
    Decode.string
        |> Decode.field "stringValue"
        |> Field


{-| -}
list : Field a -> Field (List a)
list (Field elementDecoder) =
    Decode.list elementDecoder
        |> Decode.field "values"
        |> Decode.field "arrayValue"
        |> Field


{-| -}
dict : Field a -> Field (Dict.Dict String a)
dict (Field valueDecoder) =
    Decode.dict valueDecoder
        |> Decode.field "fields"
        |> Decode.field "mapValue"
        |> Field


{-| -}
maybe : Field a -> Field (Maybe a)
maybe (Field valueDecoder) =
    Decode.nullable valueDecoder
        |> Decode.field "nullValue"
        |> Field


{-| -}
timestamp : Field Time.Posix
timestamp =
    Iso8601.decoder
        |> Decode.field "timestampValue"
        |> Field


{-| -}
geopoint : Field Geopoint.Geopoint
geopoint =
    Decode.succeed (\lat long -> Geopoint.new { latitude = lat, longitude = long })
        |> Pipeline.required "latitude" Decode.int
        |> Pipeline.required "longitude" Decode.int
        |> Decode.field "geoPointValue"
        |> Field


{-| -}
reference : Field Reference.Reference
reference =
    Decode.string
        |> Decode.field "referenceValue"
        |> Decode.map Reference.new
        |> Field
