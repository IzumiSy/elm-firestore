module Firestore.Types.Reference exposing (Reference, decoder, encoder)

{-|

@docs Reference, decoder, encoder

-}

import Firestore.Documents.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


type Reference
    = Reference String


decoder : Decode.Decoder Reference
decoder =
    Decode.field "referenceValue" <| Decode.map Reference Decode.string


encoder : Reference -> Field.Field
encoder (Reference value) =
    Field.new <|
        Encode.object
            [ ( "referenceValue", Encode.string value ) ]
