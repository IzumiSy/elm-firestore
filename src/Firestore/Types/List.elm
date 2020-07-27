module Firestore.Types.List exposing (decoder, encoder)

{-| List data type for Firestore

@docs decoder, encoder

-}

import Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (List a)
decoder elementDecoder =
    Decode.list elementDecoder
        |> Decode.field "values"
        |> Decode.field "arrayValue"


{-| -}
encoder : List a -> (a -> Document.Field) -> Document.Field
encoder value valueEncoder =
    Document.field <|
        Encode.object
            [ ( "arrayValue"
              , Encode.object
                    [ ( "values"
                      , Encode.list (Document.unwrapField << valueEncoder) value
                      )
                    ]
              )
            ]
