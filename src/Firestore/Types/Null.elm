module Firestore.Types.Null exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Firestore.Document.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (Maybe a)
decoder valueDecoder =
    Decode.field "nullValue" <| Decode.nullable valueDecoder


{-| -}
encoder : Maybe ( a, a -> Encode.Value ) -> Field.Field
encoder maybeValueAndEncoder =
    Field.new <|
        Encode.object
            [ ( "nullValue"
              , maybeValueAndEncoder
                    |> Maybe.map (\( value, valueEncoder ) -> valueEncoder value)
                    |> Maybe.withDefault Encode.null
              )
            ]
