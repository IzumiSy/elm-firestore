module Tests.Path exposing (suite)

import Expect
import Firestore.Internals.Path as InternalPath
import Test


suite : Test.Test
suite =
    Test.describe "path"
        [ Test.test "validation ok 1" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument "user1"
                    |> InternalPath.validate
                    |> Expect.ok
        , Test.test "validation ok 2" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument "user.1"
                    |> InternalPath.validate
                    |> Expect.ok
        , Test.test "validation err 1" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users/user1"
                    |> InternalPath.validate
                    |> Expect.err
        , Test.test "validation err 2" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument "user1"
                    |> InternalPath.addCollection "..dicts"
                    |> InternalPath.validate
                    |> Expect.err
        , Test.test "validation err 3" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument (String.repeat 1500 "u" ++ "1")
                    |> InternalPath.validate
                    |> Expect.err
        ]
