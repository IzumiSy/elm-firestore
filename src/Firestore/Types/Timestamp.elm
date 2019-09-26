module Firestore.Types.Timestamp exposing (Timestamp, decoder, toPosix, encoder)

{-|

@docs Timestamp, decoder, toPosix, encoder

-}

import Iso8601
import Json.Decode as Decode
import Json.Encode as Encode
import Time


type Timestamp
    = Timestamp Time.Posix


decoder : Decode.Decoder Timestamp
decoder =
    Decode.field "timestampValue" <| Decode.map Timestamp Iso8601.decoder


encoder : Timestamp -> Encode.Value
encoder (Timestamp value) =
    Encode.object
        [ ( "timestampValue", Iso8601.encode value ) ]


toPosix : Timestamp -> Time.Posix
toPosix (Timestamp posix) =
    posix
