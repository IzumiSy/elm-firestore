module Tests.Codec exposing (suite)

import Expect
import Firestore.Codec as Codec
import Test


type alias User =
    { name : String
    , age : Int
    }


suite : Test.Test
suite =
    Test.describe "codec"
        [ Test.test "encoder and decoder" <|
            \_ ->
                let
                    _ =
                        Codec.document User
                            |> Codec.required "name" .name Codec.string
                            |> Codec.required "age" .age Codec.int
                            |> Codec.build
                in
                Expect.true "codec is compilable" True
        ]
