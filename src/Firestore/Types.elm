module Firestore.Types exposing (string, int, reference, timestamp, bool, null, list, geopoint, GeoPoint, map)

{-| Decoders for Firestore builtin types

@docs string, int, reference, timestamp, bool, null, list, geopoint, GeoPoint, map

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
