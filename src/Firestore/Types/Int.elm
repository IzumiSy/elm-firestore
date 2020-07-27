module Firestore.Types.Int exposing (decoder, encoder)

{-| Integer data type for Firestore

@docs decoder, encoder

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Encode as Encode


{-| -}
decoder : Decode.Decoder Int
decoder =
    Decode.field "integerValue" Decode.string
        |> Decode.andThen
            (\value ->
                value
                    |> String.toInt
                    |> Maybe.map Decode.succeed
                    |> Maybe.withDefault (Decode.fail "Unconvertable string to int")
            )


{-| -}
encoder : Int -> Field.Field
encoder value =
    Field.field <|
        Encode.object
            [ ( "integerValue", Encode.string <| String.fromInt value ) ]
