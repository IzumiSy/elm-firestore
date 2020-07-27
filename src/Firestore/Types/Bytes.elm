module Firestore.Types.Bytes exposing (decoder, encoder)

{-| Byte data type for Firestore

@docs decoder, encoder

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder String
decoder =
    Decode.field "bytesValue" Decode.string


{-| -}
encoder : String -> Field.Field
encoder value =
    Field.field <|
        Encode.object
            [ ( "bytesValue", Encode.string value ) ]
