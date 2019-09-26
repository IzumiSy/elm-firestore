module Firestore.Types.String exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder String
decoder =
    Decode.field "stringValue" Decode.string


encoder : String -> Encode.Value
encoder value =
    Encode.object
        [ ( "stringValue", Encode.string value ) ]
