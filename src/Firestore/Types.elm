module Firestore.Types exposing (string, int, reference, timestamp, bool, null, list, geopoint, GeoPoint, map, bytes)

{-| Decoders for Firestore builtin types
More information at <https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value>

@docs string, int, reference, timestamp, bool, null, list, geopoint, GeoPoint, map, bytes

-}

import Dict
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


string : Decode.Decoder String
string =
    Decode.field "stringValue" Decode.string


int : Decode.Decoder Int
int =
    Decode.field "integerValue" Decode.string
        |> Decode.andThen
            (\value ->
                case String.toInt value of
                    Just value_ ->
                        Decode.succeed value_

                    Nothing ->
                        Decode.fail "Unconvertable string to int"
            )


reference : Decode.Decoder String
reference =
    Decode.field "referenceValue" Decode.string


timestamp : Decode.Decoder String
timestamp =
    Decode.field "timestampValue" Decode.string


bytes : Decode.Decoder String
bytes =
    Decode.field "bytesValue" Decode.string


bool : Decode.Decoder Bool
bool =
    Decode.field "booleanValue" Decode.bool


null : Decode.Decoder a -> Decode.Decoder (Maybe a)
null decoder =
    Decode.field "nullValue" <| Decode.nullable decoder


list : Decode.Decoder a -> Decode.Decoder (List a)
list decoder =
    Decode.field "arrayValue" <| Decode.field "values" <| Decode.list decoder


map : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
map decoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict decoder


type alias GeoPoint =
    { latitude : Int
    , longitude : Int
    }


geopointDecoder : Decode.Decoder GeoPoint
geopointDecoder =
    Decode.succeed GeoPoint
        |> Pipeline.required "latitude" Decode.int
        |> Pipeline.required "longitude" Decode.int


geopoint : Decode.Decoder GeoPoint
geopoint =
    Decode.field "geoPointValue" geopointDecoder
