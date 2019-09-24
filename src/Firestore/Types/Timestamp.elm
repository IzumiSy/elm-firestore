module Firestore.Types.Timestamp exposing (Timestamp, decoder, toPosix)

{-|

@docs Timestamp, decoder, toPosix

-}

import Iso8601
import Json.Decode as Decode
import Time


type Timestamp
    = Timestamp Time.Posix


decoder : Decode.Decoder Timestamp
decoder =
    Iso8601.decoder |> Decode.map Timestamp


toPosix : Timestamp -> Time.Posix
toPosix (Timestamp posix) =
    posix
