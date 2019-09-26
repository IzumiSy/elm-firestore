module Firestore.Types.String exposing (decoder)

{-|

@docs decoder

-}

import Json.Decode as Decode


decoder : Decode.Decoder String
decoder =
    Decode.field "stringValue" Decode.string
