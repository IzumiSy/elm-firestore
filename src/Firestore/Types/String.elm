module Firestore.Types.String exposing (decoder, encoder)

{-| A string data type for Firestore

@docs decoder, encoder

-}

import Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder String
decoder =
    Decode.field "stringValue" Decode.string


{-| -}
encoder : String -> Document.Field
encoder value =
    Document.field <|
        Encode.object
            [ ( "stringValue", Encode.string value ) ]
