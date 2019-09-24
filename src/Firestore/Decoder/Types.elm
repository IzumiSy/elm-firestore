module Firestore.Decoder.Types exposing (string, integer, reference, timestamp, boolean, null, array, geopoint)

{-| Decoders for Firestore builtin types

@docs string, integer, reference, timestamp, boolean, null, array, geopoint

-}

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


string : Decode.Decoder String
string =
    Decode.at [ "stringValue" ] Decode.string


integer : Decode.Decoder Int
integer =
    Decode.at [ "integerValue" ] Decode.int


reference : Decode.Decoder String
reference =
    Decode.at [ "referenceValue" ] Decode.string


timestamp : Decode.Decoder String
timestamp =
    Decode.at [ "timestampValue" ] Decode.string


boolean : Decode.Decoder Bool
boolean =
    Decode.at [ "booleanValue" ] Decode.bool


null : Decode.Decoder a -> Decode.Decoder (Maybe a)
null decoder =
    Decode.at [ "nullValue" ] (Decode.nullable decoder)


array : Decode.Decoder a -> Decode.Decoder (List a)
array decoder =
    Decode.at [ "arrayValue" ] (Decode.list decoder)


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
    Decode.at [ "geoPointValue" ] geopointDecoder
