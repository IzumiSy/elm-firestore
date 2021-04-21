module Firestore.Internals.Encode exposing
    ( bool
    , bytes
    , dict
    , geopoint
    , int
    , list
    , maybe
    , null
    , reference
    , string
    , timestamp
    )

import Dict
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Iso8601
import Json.Encode as Encode
import Time


bool : Bool -> Encode.Value
bool value =
    Encode.object
        [ ( "booleanValue", Encode.bool value ) ]


bytes : String -> Encode.Value
bytes value =
    Encode.object
        [ ( "bytesValue", Encode.string value ) ]


int : Int -> Encode.Value
int value =
    Encode.object
        [ ( "integerValue", Encode.string <| String.fromInt value ) ]


string : String -> Encode.Value
string value =
    Encode.object
        [ ( "stringValue", Encode.string value ) ]


list : (a -> Encode.Value) -> List a -> Encode.Value
list valueEncoder value =
    Encode.object
        [ ( "arrayValue"
          , Encode.object
                [ ( "values"
                  , Encode.list valueEncoder value
                  )
                ]
          )
        ]


dict : (a -> Encode.Value) -> Dict.Dict String a -> Encode.Value
dict valueEncoder value =
    Encode.object
        [ ( "mapValue"
          , Encode.object
                [ ( "fields"
                  , Encode.dict identity valueEncoder value
                  )
                ]
          )
        ]


null : Encode.Value
null =
    Encode.object [ ( "nullValue", Encode.null ) ]


maybe : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybe valueEncoder =
    Maybe.map valueEncoder
        >> Maybe.withDefault null


timestamp : Time.Posix -> Encode.Value
timestamp value =
    Encode.object
        [ ( "timestampValue", Iso8601.encode value ) ]


geopoint : Geopoint.Geopoint -> Encode.Value
geopoint geopoint_ =
    Encode.object
        [ ( "geoPointValue"
          , Encode.object
                [ ( "latitude", Encode.int <| Geopoint.latitude geopoint_ )
                , ( "longitude", Encode.int <| Geopoint.longitude geopoint_ )
                ]
          )
        ]


reference : Reference.Reference -> Encode.Value
reference reference_ =
    Encode.object
        [ ( "referenceValue", Encode.string <| Reference.toString reference_ ) ]
