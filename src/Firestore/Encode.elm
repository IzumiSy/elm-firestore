module Firestore.Encode exposing
    ( Encoder, encode, Field
    , document, merge
    , bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    )

{-| Encoders for Firestore

@docs Encoder, encode, Field


# Constructors

@docs document, merge


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
    = Encoder (List ( String, InternalTypes.ValidatedField ))


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> JsonEncode.Value
encode (Encoder fields) =
    fields
        |> List.map (\( key, InternalTypes.ValidatedField field ) -> ( key, field ))
        |> JsonEncode.object


{-| A field identifier type for Firestore encoder
-}
type Field a
    = Field JsonEncode.Value



-- Constructors


{-| Creates a new encoder

This function works like `Encode.object` but accepts a list of tuples which has only encoders provided from `Firestore.Encode` module

    Firestore.Encode.document
        [ ( "name", Firestore.Encode.string "IzumiSy" )
        , ( "age", Firestore.Encode.int 26 )
        , ( "canCode", Firestore.Encode.bool True )
        ]

-}
document : List ( String, Field a ) -> Encoder
document =
    Encoder
        << List.map (\( key, Field field ) -> ( key, InternalTypes.ValidatedField field ))


{-| Merges encoders

This function simply merges two encoders into one. It does not deal with field duplication.

-}
merge : Encoder -> Encoder -> Encoder
merge (Encoder a) (Encoder b) =
    Encoder <| a ++ b



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
