module Firestore.Types.List exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder a -> Decode.Decoder (List a)
decoder elementDecoder =
    Decode.field "arrayValue" <| Decode.field "values" <| Decode.list elementDecoder


encoder : List a -> (a -> Encode.Value) -> Encode.Value
encoder value valueEncoder =
    Encode.object
        [ ( "arrayValue"
          , Encode.object
                [ ( "values"
                  , Encode.list valueEncoder value
                  )
                ]
          )
        ]
