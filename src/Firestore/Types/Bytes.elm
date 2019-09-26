module Firestore.Types.Bytes exposing (decoder)

{-|

@docs decoder

-}

import Json.Decode as Decode


decoder : Decode.Decoder String
decoder =
    Decode.field "bytesValue" Decode.string
