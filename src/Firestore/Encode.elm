module Firestore.Encode exposing
    ( Encoder, encode
    , document
    , Field, bool, bytes, int, string, list, dict, nullable, timestamp, geopoint, reference
    , maybe
    )

{-| Encoders for Firestore

@docs Encoder, encode


# Constructors

@docs document


# Types

@docs Field, bool, bytes, int, string, list, dict, nullable, timestamp, geopoint, reference


# DEPRECATED

@docs maybe

-}

import Dict
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Iso8601
import Json.Encode as Encode
import Time


{-| An encoder consisted of Firestore specific encoders.

This can be encoded into `Json.Value` through `encode` function.

-}
type Encoder
    = Encoder (List ( String, Field ))


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> Encode.Value
encode (Encoder fields) =
    Encode.object
        [ ( "fields"
          , fields
                |> List.map (\( key, Field field ) -> ( key, field ))
                |> Encode.object
          )
        ]



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


{-| An identifier type for Firestore encoder
-}
type Field
    = Field Encode.Value


{-| -}
bool : Bool -> Field
bool value =
    Field <|
        Encode.object
            [ ( "booleanValue", Encode.bool value ) ]


{-| -}
bytes : String -> Field
bytes value =
    Field <|
        Encode.object
            [ ( "bytesValue", Encode.string value ) ]


{-| -}
int : Int -> Field
int value =
    Field <|
        Encode.object
            [ ( "integerValue", Encode.string <| String.fromInt value ) ]


{-| -}
string : String -> Field
string value =
    Field <|
        Encode.object
            [ ( "stringValue", Encode.string value ) ]


{-| -}
list : List a -> (a -> Field) -> Field
list value valueEncoder =
    Field <|
        Encode.object
            [ ( "arrayValue"
              , Encode.object
                    [ ( "values"
                      , Encode.list ((\(Field field) -> field) << valueEncoder) value
                      )
                    ]
              )
            ]


{-| -}
dict : Dict.Dict String a -> (a -> Field) -> Field
dict value valueEncoder =
    Field <|
        Encode.object
            [ ( "mapValue"
              , Encode.object
                    [ ( "fields"
                      , Encode.dict identity ((\(Field field) -> field) << valueEncoder) value
                      )
                    ]
              )
            ]


{-| Note: This will be renamed to `maybe` in the next major version
-}
nullable : (a -> Encode.Value) -> Maybe a -> Field
nullable valueEncoder maybeValue =
    Field <|
        Encode.object
            [ ( "nullValue"
              , maybeValue
                    |> Maybe.map valueEncoder
                    |> Maybe.withDefault Encode.null
              )
            ]


{-| DEPRECATED. Use `nullable` instead
-}
maybe : Maybe ( a, a -> Encode.Value ) -> Field
maybe maybeValueAndEncoder =
    Field <|
        Encode.object
            [ ( "nullValue"
              , maybeValueAndEncoder
                    |> Maybe.map (\( value, valueEncoder ) -> valueEncoder value)
                    |> Maybe.withDefault Encode.null
              )
            ]


{-| -}
timestamp : Time.Posix -> Field
timestamp value =
    Field <|
        Encode.object
            [ ( "timestampValue", Iso8601.encode value ) ]


{-| -}
geopoint : Geopoint.Geopoint -> Field
geopoint geopoint_ =
    Field <|
        Encode.object
            [ ( "geoPointValue"
              , Encode.object
                    [ ( "latitude", Encode.int <| Geopoint.latitude geopoint_ )
                    , ( "longitude", Encode.int <| Geopoint.longitude geopoint_ )
                    ]
              )
            ]


{-| -}
reference : Reference.Reference -> Field
reference reference_ =
    Field <|
        Encode.object
            [ ( "referenceValue", Encode.string <| Reference.toString reference_ ) ]
