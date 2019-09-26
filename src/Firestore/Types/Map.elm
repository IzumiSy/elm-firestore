module Firestore.Types.Map exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Dict
import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
decoder valueDecoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict valueDecoder


encoder : Dict.Dict String a -> (a -> Encode.Value) -> Encode.Value
encoder value valueEncoder =
    Encode.object
        [ ( "mapValue"
          , Encode.object
                [ ( "fields"
                  , Encode.dict identity valueEncoder value
                  )
                ]
          )
        ]
