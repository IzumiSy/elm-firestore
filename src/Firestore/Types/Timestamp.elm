module Firestore.Types.Timestamp exposing (Timestamp, decoder, toPosix, encoder)

{-|

@docs Timestamp, decoder, toPosix, encoder

-}

import Firestore.Document.Field as Field
import Iso8601
import Json.Decode as Decode
import Json.Encode as Encode
import Time


type Timestamp
    = Timestamp Time.Posix


decoder : Decode.Decoder Timestamp
decoder =
    Decode.field "timestampValue" <| Decode.map Timestamp Iso8601.decoder


encoder : Timestamp -> Field.Field
encoder (Timestamp value) =
    Field.new <|
        Encode.object
            [ ( "timestampValue", Iso8601.encode value ) ]


toPosix : Timestamp -> Time.Posix
toPosix (Timestamp posix) =
    posix
