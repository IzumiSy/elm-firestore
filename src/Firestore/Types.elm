module Firestore.Types exposing (string, int, reference, timestamp, bool, null, list, geopoint, map, bytes)

{-| Decoders for Firestore builtin types
More information at <https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value>

@docs string, int, reference, timestamp, bool, null, list, geopoint, GeoPoint, map, bytes

-}

import Dict
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Firestore.Types.Timestamp as Timestamp
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
                value
                    |> String.toInt
                    |> Maybe.map Decode.succeed
                    |> Maybe.withDefault (Decode.fail "Unconvertable string to int")
            )


reference : Decode.Decoder Reference.Reference
reference =
    Decode.field "referenceValue" Decode.string |> Decode.map Reference.new


timestamp : Decode.Decoder Timestamp.Timestamp
timestamp =
    Decode.field "timestampValue" Decode.string |> Decode.map Timestamp.new


geopoint : Decode.Decoder Geopoint.Geopoint
geopoint =
    Decode.field "geoPointValue" Geopoint.decoder


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
