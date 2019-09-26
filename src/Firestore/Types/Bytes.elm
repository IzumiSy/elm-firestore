module Firestore.Types.Bytes exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder String
decoder =
    Decode.field "bytesValue" Decode.string


encoder : String -> Encode.Value
encoder value =
    Encode.object
        [ ( "bytesValue", Encode.string value ) ]
