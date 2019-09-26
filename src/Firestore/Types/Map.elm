module Firestore.Types.Map exposing (decoder)

{-|

@docs decoder

-}

import Dict
import Json.Decode as Decode


decoder : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
decoder valueDecoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict valueDecoder
