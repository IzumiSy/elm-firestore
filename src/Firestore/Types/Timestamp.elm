module Firestore.Types.Timestamp exposing
    ( Timestamp, new, decoder, encoder
    , toPosix
    )

{-| Timestamp data type for Firestore

@docs Timestamp, new, decoder, encoder


# Extractors

@docs toPosix

-}

import Firestore.Internals.Field as Field
import Iso8601
import Json.Decode as Decode
import Json.Encode as Encode
import Time


{-| -}
type Timestamp
    = Timestamp Time.Posix


{-| -}
new : Time.Posix -> Timestamp
new =
    Timestamp


{-| -}
decoder : Decode.Decoder Timestamp
decoder =
    Decode.field "timestampValue" <| Decode.map Timestamp Iso8601.decoder


{-| -}
encoder : Timestamp -> Field.Field
encoder (Timestamp value) =
    Field.field <|
        Encode.object
            [ ( "timestampValue", Iso8601.encode value ) ]


{-| -}
toPosix : Timestamp -> Time.Posix
toPosix (Timestamp posix) =
    posix
