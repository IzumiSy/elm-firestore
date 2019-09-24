module Firestore.Types.Reference exposing (Reference, decoder)

{-|

@docs Reference, decoder

-}

import Json.Decode as Decode


type Reference
    = Reference String


decoder : Decode.Decoder Reference
decoder =
    Decode.string |> Decode.map Reference
