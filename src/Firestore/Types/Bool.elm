module Firestore.Types.Bool exposing (decoder, encoder)

{-| Boolean data type for Firestore

@docs decoder, encoder

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder Bool
decoder =
    Decode.field "booleanValue" Decode.bool


{-| -}
encoder : Bool -> Field.Field
encoder value =
    Field.field <|
        Encode.object
            [ ( "booleanValue", Encode.bool value ) ]
