module Firestore.Types.Reference exposing (Reference, new, decoder, encoder)

{-| Reference data type for Firestore

@docs Reference, new, decoder, encoder

-}

import Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
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
