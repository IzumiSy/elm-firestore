module Firestore.Types.Reference exposing (Reference, decoder, encoder)

{-|

@docs Reference, decoder, encoder

-}

import Json.Decode as Decode
import Json.Encode as Encode


type Reference
    = Reference String


decoder : Decode.Decoder Reference
decoder =
    Decode.field "referenceValue" <| Decode.map Reference Decode.string


encoder : Reference -> Encode.Value
encoder (Reference value) =
    Encode.object
        [ ( "referenceValue", Encode.string value ) ]
