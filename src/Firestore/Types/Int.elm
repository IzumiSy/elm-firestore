module Firestore.Types.Int exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Json.Decode as Decode
import Json.Encode as Encode


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


encoder : Int -> Encode.Value
encoder value =
    Encode.object
        [ ( "intergerValue", Encode.string <| String.fromInt value ) ]
