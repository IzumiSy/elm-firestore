module Firestore.Types.Bool exposing (decoder, encoder)

{-| Boolean data type for Firestore

@docs decoder, encoder

-}

import Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder Bool
decoder =
    Decode.field "booleanValue" Decode.bool


{-| -}
encoder : Bool -> Document.Field
encoder value =
    Document.field <|
        Encode.object
            [ ( "booleanValue", Encode.bool value ) ]
