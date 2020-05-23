module Firestore.Types.Bytes exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Firestore.Document.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder String
decoder =
    Decode.field "bytesValue" Decode.string


{-| -}
encoder : String -> Field.Field
encoder value =
    Field.new <|
        Encode.object
            [ ( "bytesValue", Encode.string value ) ]
