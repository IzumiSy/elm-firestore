module Firestore.Types.Bool exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Firestore.Documents.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder Bool
decoder =
    Decode.field "booleanValue" Decode.bool


encoder : Bool -> Field.Field
encoder value =
    Field.new <|
        Encode.object
            [ ( "booleanValue", Encode.bool value ) ]
