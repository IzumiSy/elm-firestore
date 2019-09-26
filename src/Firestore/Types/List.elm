module Firestore.Types.List exposing (decoder)

{-|

@docs decoder

-}

import Json.Decode as Decode


decoder : Decode.Decoder a -> Decode.Decoder (List a)
decoder elementDecoder =
    Decode.field "arrayValue" <| Decode.field "values" <| Decode.list elementDecoder
