module Firestore.Types.Int exposing (decoder)

{-|

@docs decoder

-}

import Json.Decode as Decode


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
