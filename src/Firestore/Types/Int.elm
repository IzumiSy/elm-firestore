module Firestore.Types.Int exposing (decoder, encoder)

{-|

@docs decoder, encoder

-}

import Firestore.Document as Document
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
encoder : Int -> Document.Field
encoder value =
    Document.field <|
        Encode.object
            [ ( "integerValue", Encode.string <| String.fromInt value ) ]
