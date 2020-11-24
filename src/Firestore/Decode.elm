module Firestore.Decode exposing
    ( Decoder, decode
    , document, required, optional
    , Field, bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    , map, andThen, succeed, fail
    )

{-| Decoders for Firestore

@docs Decoder, decode


# Constructors

@docs document, required, optional


# Types

@docs Field, bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference


# Utility Functions

@docs map, andThen, succeed, fail

-}

import Dict
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Time


{-| A decoder consisted of Firestore specific decoders.

`Json.Decode.Decoder` can be generate from this through `decode` function.

-}
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


{-| Decodes a required field.

This function is internally delegated into [`json.Decode.Pipeline.required`][required].

[required]: https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest/Json-Decode-Pipeline#required

-}
required : String -> Field a -> Decoder (a -> b) -> Decoder b
required name (Field fieldDecoder) (Decoder encoder) =
    Decoder <| Pipeline.required name fieldDecoder encoder


{-| Decodes an optional field.

This function is internally delegated into [`Json.Decode.Pipeline.optional`][optional].

[optional]: https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest/Json-Decode-Pipeline#optional

-}
optional : String -> Field a -> a -> Decoder (a -> b) -> Decoder b
optional name (Field fieldDecoder) default (Decoder encoder) =
    Decoder <| Pipeline.optional name fieldDecoder default encoder



-- Types


{-| An identifier type for Firestore encoder
-}
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
null : Field ()
null =
    Decode.null ()
        |> Decode.field "nullValue"
        |> Field


{-| -}
maybe : Field a -> Field (Maybe a)
maybe (Field valueDecoder) =
    let
        (Field nullDecoder) =
            null
    in
    Decode.oneOf
        [ nullDecoder |> Decode.map (\() -> Nothing)
        , valueDecoder |> Decode.map Just
        ]
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


{-| -}
map : (a -> b) -> Field a -> Field b
map fun (Field valueDecoder) =
    valueDecoder
        |> Decode.map fun
        |> Field


{-| -}
andThen : (a -> Field b) -> Field a -> Field b
andThen fun (Field valueDecoder) =
    valueDecoder
        |> Decode.andThen
            (\a ->
                let
                    (Field valueDecoderNew) =
                        fun a
                in
                valueDecoderNew
            )
        |> Field


{-| -}
succeed : a -> Field a
succeed =
    Decode.succeed
        >> Field


{-| -}
fail : String -> Field a
fail =
    Decode.fail
        >> Field
