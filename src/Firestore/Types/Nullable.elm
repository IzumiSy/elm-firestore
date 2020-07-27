module Firestore.Types.Nullable exposing (decoder, encoder)

{-| Nullable data type for Firestore

@docs decoder, encoder

-}

import Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (Maybe a)
decoder valueDecoder =
    Decode.field "nullValue" <| Decode.nullable valueDecoder


{-| -}
encoder : Maybe ( a, a -> Encode.Value ) -> Document.Field
encoder maybeValueAndEncoder =
    Document.field <|
        Encode.object
            [ ( "nullValue"
              , maybeValueAndEncoder
                    |> Maybe.map (\( value, valueEncoder ) -> valueEncoder value)
                    |> Maybe.withDefault Encode.null
              )
            ]
