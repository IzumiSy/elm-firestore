module Firestore.Types.Reference exposing (Reference, new, decoder, encoder)

{-| Reference data type for Firestore

@docs Reference, new, decoder, encoder

-}

import Firestore.Internals.Field as Field
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
encoder : Reference -> Field.Field
encoder (Reference value) =
    Field.field <|
        Encode.object
            [ ( "referenceValue", Encode.string value ) ]
