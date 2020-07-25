module Firestore.Types.Map exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Dict
import Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (Dict.Dict String a)
decoder valueDecoder =
    Decode.field "mapValue" <| Decode.field "fields" <| Decode.dict valueDecoder


{-| -}
encoder : Dict.Dict String a -> (a -> Document.Field) -> Document.Field
encoder value valueEncoder =
    Document.field <|
        Encode.object
            [ ( "mapValue"
              , Encode.object
                    [ ( "fields"
                      , Encode.dict identity (Document.unwrapField << valueEncoder) value
                      )
                    ]
              )
            ]
