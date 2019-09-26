module Firestore.Types.Bool exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder Bool
decoder =
    Decode.field "booleanValue" Decode.bool


encoder : Bool -> Encode.Value
encoder value =
    Encode.object
        [ ( "booleanValue", Encode.bool value ) ]
