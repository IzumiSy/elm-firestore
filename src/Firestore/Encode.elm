module Firestore.Encode exposing
    ( Encoder, encode
    , Builder, new, field, Field, build, merge
    , bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    )

{-| Encoders for Firestore

@docs Encoder, encode


# Constructors

@docs Builder, new, field, Field, build, merge


# Types

@docs bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference

-}

import Dict
import Firestore.Internals.Encode as Encode
import Firestore.Internals.Types as InternalTypes
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Json.Encode as JsonEncode
import Time


{-| An encoder consisted of Firestore specific encoders.

This can be encoded into `Json.Value` through `encode` function.

-}
type Encoder
    = Encoder (Dict.Dict String InternalTypes.ValidatedField)


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> JsonEncode.Value
encode (Encoder fields) =
    fields
        |> Dict.toList
        |> List.map (\( key, InternalTypes.ValidatedField field_ ) -> ( key, field_ ))
        |> JsonEncode.object



-- Constructors


type Builder a
    = Builder (Dict.Dict String InternalTypes.ValidatedField)


{-| A field identifier type for Firestore encoder
-}
type Field a
    = Field JsonEncode.Value


{-| Initializes a new builder for encoders
-}
new : Builder Empty
new =
    Builder Dict.empty


field : String -> (a -> Field b) -> a -> Builder c -> Builder Building
field name encoder value (Builder encoders) =
    let
        (Field field_) =
            encoder value
    in
    Builder <| Dict.insert name (InternalTypes.ValidatedField field_) encoders


{-| Generates an encoder from builders
-}
build : Builder Building -> Encoder
build (Builder value) =
    Encoder value


{-| Merges encoders

This function simply merges two encoders into one. Resolution of duplicated key is unpredictable.

-}
merge : Builder Building -> Builder Building -> Builder Building
merge (Builder a) (Builder b) =
    Builder <|
        Dict.merge
            (\key value -> Dict.insert key value)
            (\key _ value -> Dict.insert key value)
            (\key value -> Dict.insert key value)
            a
            b
            Dict.empty



-- Types


{-| -}
bool : Bool -> Field InternalTypes.Bool
bool =
    Field << Encode.bool


{-| -}
bytes : String -> Field InternalTypes.Bytes
bytes =
    Field << Encode.bytes


{-| -}
int : Int -> Field InternalTypes.Int
int =
    Field << Encode.int


{-| -}
string : String -> Field InternalTypes.String
string =
    Field << Encode.string


{-| -}
list : (a -> Field (InternalTypes.Listable b)) -> List a -> Field InternalTypes.List
list valueEncoder value =
    Field <| Encode.list (unfield << valueEncoder) value


{-| -}
dict : (a -> Field b) -> Dict.Dict String a -> Field InternalTypes.Dict
dict valueEncoder value =
    Field <| Encode.dict (unfield << valueEncoder) value


{-| -}
null : Field InternalTypes.Null
null =
    Field Encode.null


{-| -}
maybe : (a -> Field b) -> Maybe a -> Field InternalTypes.Maybe
maybe valueEncoder =
    Field << Encode.maybe (unfield << valueEncoder)


{-| -}
timestamp : Time.Posix -> Field InternalTypes.Timestamp
timestamp =
    Field << Encode.timestamp


{-| -}
geopoint : Geopoint.Geopoint -> Field InternalTypes.Geopoint
geopoint =
    Field << Encode.geopoint


{-| -}
reference : Reference.Reference -> Field InternalTypes.Reference
reference =
    Field << Encode.reference



-- Internals


unfield : Field a -> JsonEncode.Value
unfield (Field value) =
    value


type Building
    = Building


type Empty
    = Empty
