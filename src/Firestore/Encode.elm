module Firestore.Encode exposing
    ( Encoder, encode
    , Builder, new, field, Field, build
    , bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    )

{-| Encoders for Firestore

@docs Encoder, encode


# Constructors

@docs Builder, new, field, Field, build


# Types

@docs bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference

-}

import Dict
import Firestore.Internals.Encode as Encode
import Firestore.Internals.Encode.Types as EncodeTypes
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Json.Encode as JsonEncode
import Time


{-| An encoder consisted of Firestore specific encoders.

This can be encoded into `Json.Value` through `encode` function.

-}
type Encoder
    = Encoder (List ( String, JsonEncode.Value ))


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> JsonEncode.Value
encode (Encoder fields) =
    JsonEncode.object fields



-- Constructors

{-| A builder for Firestore encoders

`Json.Encode.Value` can be generated from this through `build` function.

-}
type Builder
    = Builder (Dict.Dict String ValidatedField)


{-| A field identifier type for Firestore encoder
-}
type Field a
    = Field JsonEncode.Value


{-| A field identifier witout a type tag

`Encode.Field` has a type tag for phantom typing so that is not sutiable to be used
in a part of any public types because it require users to set type variables every time in definition.

-}
type ValidatedField
    = ValidatedField JsonEncode.Value


{-| Initializes a new builder for encoders

    Firestore.Encode.new
        |> Firestore.Encode.field "name" (Firestore.Encode.string "stringValue")
        |> Firestore.Encode.field "age" (Firestore.Encode.int 10)
        |> Firestore.Encode.build

-}
new : Builder
new =
    Builder Dict.empty

{-| A function to define document fields in a builder
-}
field : String -> Field b -> Builder -> Builder
field name field_ (Builder encoders) =
    Builder <| Dict.insert name (ValidatedField (unfield field_)) encoders


{-| Generates an encoder from an instance of `Builder`
-}
build : Builder -> Encoder
build (Builder fields) =
    fields
        |> Dict.toList
        |> List.map (\( key, ValidatedField field_ ) -> ( key, field_ ))
        |> Encoder



-- Types


{-| -}
bool : Bool -> Field EncodeTypes.Bool
bool =
    Field << Encode.bool


{-| -}
bytes : String -> Field EncodeTypes.Bytes
bytes =
    Field << Encode.bytes


{-| -}
int : Int -> Field EncodeTypes.Int
int =
    Field << Encode.int


{-| -}
string : String -> Field EncodeTypes.String
string =
    Field << Encode.string


{-| -}
list : (a -> Field (EncodeTypes.CanBeListElement b)) -> List a -> Field EncodeTypes.List
list valueEncoder value =
    Field <| Encode.list (unfield << valueEncoder) value


{-| -}
dict : (a -> Field b) -> Dict.Dict String a -> Field EncodeTypes.Dict
dict valueEncoder value =
    Field <| Encode.dict (unfield << valueEncoder) value


{-| -}
null : Field EncodeTypes.Null
null =
    Field Encode.null


{-| -}
maybe : (a -> Field b) -> Maybe a -> Field EncodeTypes.Maybe
maybe valueEncoder =
    Field << Encode.maybe (unfield << valueEncoder)


{-| -}
timestamp : Time.Posix -> Field EncodeTypes.Timestamp
timestamp =
    Field << Encode.timestamp


{-| -}
geopoint : Geopoint.Geopoint -> Field EncodeTypes.Geopoint
geopoint =
    Field << Encode.geopoint


{-| -}
reference : Reference.Reference -> Field EncodeTypes.Reference
reference =
    Field << Encode.reference



-- Internals


unfield : Field a -> JsonEncode.Value
unfield (Field value) =
    value
