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
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Iso8601
import Json.Encode as Encode
import Time


{-| An encoder consisted of Firestore specific encoders.

This can be encoded into `Json.Value` through `encode` function.

-}
type Encoder
    = Encoder (Dict.Dict String Field)


{-| Generates Json.Encode.Value from Encoder
-}
encode : Encoder -> Encode.Value
encode (Encoder fields) =
    Encode.object
        [ ( "fields"
          , fields
                |> Dict.toList
                |> List.map (\( key, Field field_ ) -> ( key, field_ ))
                |> Encode.object
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
list : (a -> Field) -> List a -> Field
list valueEncoder value =
    Field <|
        Encode.object
            [ ( "arrayValue"
              , Encode.object
                    [ ( "values"
                      , Encode.list ((\(Field field_) -> field_) << valueEncoder) value
                      )
                    ]
              )
            ]


{-| -}
dict : (a -> Field) -> Dict.Dict String a -> Field
dict valueEncoder value =
    Field <|
        Encode.object
            [ ( "mapValue"
              , Encode.object
                    [ ( "fields"
                      , Encode.dict identity ((\(Field field_) -> field_) << valueEncoder) value
                      )
                    ]
              )
            ]


{-| -}
null : Field
null =
    Field <| Encode.object [ ( "nullValue", Encode.null ) ]


{-| -}
maybe : (a -> Field) -> Maybe a -> Field
maybe valueEncoder =
    Maybe.map valueEncoder
        >> Maybe.withDefault null


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
