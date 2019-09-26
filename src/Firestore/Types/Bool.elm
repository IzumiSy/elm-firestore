module Firestore.Types.Bool exposing (decoder)

{-|

@docs decoder

-}

import Json.Decode as Decode


decoder : Decode.Decoder Bool
decoder =
    Decode.field "booleanValue" Decode.bool
