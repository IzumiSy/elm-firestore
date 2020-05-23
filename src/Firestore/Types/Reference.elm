module Firestore.Types.Reference exposing (Reference, decoder, encoder, new)

{-|

@docs Reference, decoder, encoder, new

-}

import Firestore.Document.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| Reference type for Firestore
-}
type Reference
    = Reference String


{-| -}
new : String -> Reference
new =
    Reference


{-| -}
decoder : Decode.Decoder Reference
decoder =
    Decode.field "referenceValue" <| Decode.map Reference Decode.string


{-| -}
encoder : Reference -> Field.Field
encoder (Reference value) =
    Field.new <|
        Encode.object
            [ ( "referenceValue", Encode.string value ) ]
