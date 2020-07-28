module Firestore.Encode exposing (bool, bytes, int, string, list, dict, maybe, timestamp)

{-| Encoders for Firestore

@docs bool, bytes, int, string, list, dict, maybe, timestamp

-}

import Dict
import Firestore.Internals.Field as Field
import Iso8601
import Json.Encode as Encode
import Time


{-| -}
bool : Bool -> Field.Field
bool value =
    Field.field <|
        Encode.object
            [ ( "booleanValue", Encode.bool value ) ]


{-| -}
bytes : String -> Field.Field
bytes value =
    Field.field <|
        Encode.object
            [ ( "bytesValue", Encode.string value ) ]


{-| -}
int : Int -> Field.Field
int value =
    Field.field <|
        Encode.object
            [ ( "integerValue", Encode.string <| String.fromInt value ) ]


{-| -}
string : String -> Field.Field
string value =
    Field.field <|
        Encode.object
            [ ( "stringValue", Encode.string value ) ]


{-| -}
list : List a -> (a -> Field.Field) -> Field.Field
list value valueEncoder =
    Field.field <|
        Encode.object
            [ ( "arrayValue"
              , Encode.object
                    [ ( "values"
                      , Encode.list (Field.unwrap << valueEncoder) value
                      )
                    ]
              )
            ]


{-| -}
dict : Dict.Dict String a -> (a -> Field.Field) -> Field.Field
dict value valueEncoder =
    Field.field <|
        Encode.object
            [ ( "mapValue"
              , Encode.object
                    [ ( "fields"
                      , Encode.dict identity (Field.unwrap << valueEncoder) value
                      )
                    ]
              )
            ]


{-| -}
maybe : Maybe ( a, a -> Encode.Value ) -> Field.Field
maybe maybeValueAndEncoder =
    Field.field <|
        Encode.object
            [ ( "nullValue"
              , maybeValueAndEncoder
                    |> Maybe.map (\( value, valueEncoder ) -> valueEncoder value)
                    |> Maybe.withDefault Encode.null
              )
            ]


{-| -}
timestamp : Time.Posix -> Field.Field
timestamp value =
    Field.field <|
        Encode.object
            [ ( "timestampValue", Iso8601.encode value ) ]
