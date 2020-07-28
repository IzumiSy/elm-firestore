module Firestore.Decode exposing (bool, bytes, int, string, list, dict, maybe, timestamp)

{-| Decoders for Firestore

@docs bool, bytes, int, string, list, dict, maybe, timestamp

-}

import Dict
import Iso8601
import Json.Decode as Decode
import Time


{-| -}
bool : Decode.Decoder Bool
bool =
    Decode.field "booleanValue" Decode.bool


{-| -}
bytes : Decode.Decoder String
bytes =
    Decode.field "bytesValue" Decode.string


{-| -}
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


{-| -}
string : Decode.Decoder String
string =
    Decode.field "stringValue" Decode.string


{-| -}
list : Decode.Decoder a -> Decode.Decoder (List a)
list elementDecoder =
    Decode.list elementDecoder
        |> Decode.field "values"
        |> Decode.field "arrayValue"


{-| -}
dict : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
dict valueDecoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict valueDecoder


{-| -}
maybe : Decode.Decoder a -> Decode.Decoder (Maybe a)
maybe valueDecoder =
    Decode.field "nullValue" <| Decode.nullable valueDecoder


{-| -}
timestamp : Decode.Decoder Time.Posix
timestamp =
    Decode.field "timestampValue" Iso8601.decoder
