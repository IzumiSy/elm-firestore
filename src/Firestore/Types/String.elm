module Firestore.Types.String exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Firestore.Documents.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder String
decoder =
    Decode.field "stringValue" Decode.string


encoder : String -> Field.Field
encoder value =
    Field.new <|
        Encode.object
            [ ( "stringValue", Encode.string value ) ]
