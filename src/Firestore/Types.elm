module Firestore.Types exposing
    ( string, reference, timestamp, null, geopoint, GeoPoint
    , bool, int, list
    )

{-| Decoders for Firestore builtin types

@docs string, integer, reference, timestamp, boolean, null, array, geopoint, GeoPoint

-}

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