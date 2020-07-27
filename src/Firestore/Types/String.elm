module Firestore.Types.String exposing (decoder, encoder)

{-| String data type for Firestore

@docs decoder, encoder

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder String
decoder =
    Decode.field "stringValue" Decode.string


{-| -}
encoder : String -> Field.Field
encoder value =
    Field.field <|
        Encode.object
            [ ( "stringValue", Encode.string value ) ]
