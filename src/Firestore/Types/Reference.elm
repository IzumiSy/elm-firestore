module Firestore.Types.Reference exposing (Reference, decoder)

{-|

@docs Reference, decoder

-}

import Json.Decode as Decode


type Reference
    = Reference String


decoder : Decode.Decoder Reference
decoder =
    Decode.field "referenceValue" <| Decode.map Reference Decode.string
