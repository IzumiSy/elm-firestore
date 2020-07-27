module Firestore.Types.List exposing (decoder, encoder)

{-| List data type for Firestore

@docs decoder, encoder

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (List a)
decoder elementDecoder =
    Decode.list elementDecoder
        |> Decode.field "values"
        |> Decode.field "arrayValue"


{-| -}
encoder : List a -> (a -> Field.Field) -> Field.Field
encoder value valueEncoder =
    Field.field <|
        Encode.object
            [ ( "arrayValue"
              , Encode.object
                    [ ( "values"
                      , Encode.list (Field.unwrap << valueEncoder) value
                      )
                    ]
              )
            ]
