module Firestore.Types.Reference exposing (Reference, decoder, encoder, new)

{-| A reference data type for Firestore

@docs Reference, decoder, encoder, new

-}

import Firestore.Document as Document
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
encoder : Reference -> Document.Field
encoder (Reference value) =
    Document.field <|
        Encode.object
            [ ( "referenceValue", Encode.string value ) ]
