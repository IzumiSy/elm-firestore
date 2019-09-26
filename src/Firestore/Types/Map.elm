module Firestore.Types.Map exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Dict
import Firestore.Document.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


decoder : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
decoder valueDecoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict valueDecoder


encoder : Dict.Dict String a -> (a -> Encode.Value) -> Field.Field
encoder value valueEncoder =
    Field.new <|
        Encode.object
            [ ( "mapValue"
              , Encode.object
                    [ ( "fields"
                      , Encode.dict identity valueEncoder value
                      )
                    ]
              )
            ]
