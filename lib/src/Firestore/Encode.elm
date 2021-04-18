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
    = Encoder (List ( String, Field ))


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> JsonEncode.Value
encode (Encoder fields) =
    JsonEncode.object
        [ ( "fields"
          , fields
                |> List.map (\( key, Field field ) -> ( key, field ))
                |> JsonEncode.object
          )
        ]


{-| An field identifier type for Firestore encoder
-}
type Field
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
document : List ( String, Field ) -> Encoder
document =
    Encoder



-- Types


{-| -}
bool : Bool -> Field
bool =
    Field << Encode.bool


{-| -}
bytes : String -> Field
bytes =
    Field << Encode.bytes


{-| -}
int : Int -> Field
int =
    Field << Encode.int


{-| -}
string : String -> Field
string =
    Field << Encode.string


{-| -}
list : (a -> Field) -> List a -> Field
list valueEncoder value =
    Field <| Encode.list (unfield << valueEncoder) value


{-| -}
dict : (a -> Field) -> Dict.Dict String a -> Field
dict valueEncoder value =
    Field <| Encode.dict (unfield << valueEncoder) value


{-| -}
null : Field
null =
    Field Encode.null


{-| -}
maybe : (a -> Field) -> Maybe a -> Field
maybe valueEncoder =
    Field << Encode.maybe (unfield << valueEncoder)


{-| -}
timestamp : Time.Posix -> Field
timestamp =
    Field << Encode.timestamp


{-| -}
geopoint : Geopoint.Geopoint -> Field
geopoint =
    Field << Encode.geopoint


{-| -}
reference : Reference.Reference -> Field
reference =
    Field << Encode.reference



-- Internals


unfield : Field -> JsonEncode.Value
unfield (Field value) =
    value
