module Firestore.Encode exposing
    ( Encoder, Field, encode
    , document, field, encoder
    , bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    )

{-| Encoders for Firestore

@docs Encoder, Field, encode


# Constructors

@docs document, field, encoder


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
    = Encoder (Dict.Dict String Field)


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> JsonEncode.Value
encode (Encoder fields) =
    JsonEncode.object
        [ ( "fields"
          , fields
                |> Dict.toList
                |> List.map (\( key, Field field_ ) -> ( key, field_ ))
                |> JsonEncode.object
          )
        ]



-- Constructors


type OneOrMoreField
    = OneOrMoreField


type Document a
    = Document Encoder


{-| Begins a new encoder
-}
document : Document a
document =
    Document <| Encoder Dict.empty


{-| Defines a new field in an encoder
-}
field : String -> Field -> Document a -> Document OneOrMoreField
field name field_ (Document (Encoder fields)) =
    Document <| Encoder <| Dict.insert name field_ fields


{-| Generates Firestore.Encoder

This function is a finalizer for encoder constructing functions.

    Firestore.Encode.document
        |> Firestore.Encode.field "name" (Firestore.Encode.string "IzumiSy") )
        |> Firestore.Encode.field "age" (Firestore.Encode.int 26)
        |> Firestore.Encode.field "canCode" (Firestore.Encode.bool True)
        |> Firestore.Encode.encoder

-}
encoder : Document OneOrMoreField -> Encoder
encoder (Document encoder_) =
    encoder_



-- Types


{-| An identifier type for Firestore encoder
-}
type Field
    = Field JsonEncode.Value


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
    Maybe.map valueEncoder
        >> Maybe.withDefault null


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
