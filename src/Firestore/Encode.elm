module Firestore.Encode exposing
    ( Encoder, encode, Field
    , document
    , bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    )

{-| Encoders for Firestore

@docs Encoder, encode, Field


# Constructors

@docs document


# Types

@docs bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference

-}

import Dict
import Firestore.Internals.Encode as Encode
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Json.Encode as JsonEncode
import Time


{-| An encoder consisted of Firestore specific encoders.

This can be encoded into `Json.Value` through `encode` function.

-}
type Encoder
    = Encoder (List ( String, Field a ))


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> JsonEncode.Value
encode (Encoder fields) =
    fields
        |> List.map (\( key, Field field ) -> ( key, field ))
        |> JsonEncode.object


{-| An field identifier type for Firestore encoder
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



-- Types


{-| -}
bool : Bool -> Field BoolType
bool =
    Field << Encode.bool


type alias BoolType =
    { listble : Allowed }


{-| -}
bytes : String -> Field BytesType
bytes =
    Field << Encode.bytes


type alias BytesType =
    { listable : Allowed }


{-| -}
int : Int -> Field IntType
int =
    Field << Encode.int


type alias IntType =
    { listable : Allowed }


{-| -}
string : String -> Field StringType
string =
    Field << Encode.string


type alias StringType =
    { listable : Allowed }


{-| -}
list : (a -> Field (Listable b)) -> List a -> Field ListType
list valueEncoder value =
    Field <| Encode.list (unfield << valueEncoder) value


type alias ListType =
    { listable : Denied }


{-| -}
dict : (a -> Field b) -> Dict.Dict String a -> Field DictType
dict valueEncoder value =
    Field <| Encode.dict (unfield << valueEncoder) value


type alias DictType =
    { listable : Allowed }


{-| -}
null : Field NullType
null =
    Field Encode.null


type alias NullType =
    { listable : Allowed }


{-| -}
maybe : (a -> Field b) -> Maybe a -> Field MaybeType
maybe valueEncoder =
    Field << Encode.maybe (unfield << valueEncoder)


type alias MaybeType =
    { listable : Allowed }


{-| -}
timestamp : Time.Posix -> Field TimestampType
timestamp =
    Field << Encode.timestamp


type alias TimestampType =
    { listable : Allowed }


{-| -}
geopoint : Geopoint.Geopoint -> Field GeopointType
geopoint =
    Field << Encode.geopoint


type alias GeopointType =
    { listable : Allowed }


{-| -}
reference : Reference.Reference -> Field ReferenceType
reference =
    Field << Encode.reference


type alias ReferenceType =
    { listable : Allowed }



-- Internals


unfield : Field a -> JsonEncode.Value
unfield (Field value) =
    value



-- Type tags


type Allowed
    = Allowed


type Denied
    = Denied


type alias Listable a =
    { a | listable : Allowed }
