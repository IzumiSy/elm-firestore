module Firestore.Types.Map exposing (decoder, encoder)

{-| Map data type for Firestore

@docs decoder, encoder

-}

import Dict
import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
decoder valueDecoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict valueDecoder


{-| -}
encoder : Dict.Dict String a -> (a -> Field.Field) -> Field.Field
encoder value valueEncoder =
    Field.field <|
        Encode.object
            [ ( "mapValue"
              , Encode.object
                    [ ( "fields"
                      , Encode.dict identity (Field.unwrap << valueEncoder) value
                      )
                    ]
              )
            ]
