module Firestore.Types.Null exposing (decoder)

{-|

@docs decoder

-}

import Json.Decode as Decode


decoder : Decode.Decoder a -> Decode.Decoder (Maybe a)
decoder valueDecoder =
    Decode.field "nullValue" <| Decode.nullable valueDecoder
