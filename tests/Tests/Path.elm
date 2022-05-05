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
        , Test.test "Slash in ID is invalid" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users/user1"
                    |> InternalPath.validate
                    |> Expect.err
        , Test.test "ID with two dots is invalid" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument "user1"
                    |> InternalPath.addCollection "dicts.."
                    |> InternalPath.validate
                    |> Expect.err
        , Test.test "A heading dot is invalid" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument "user1"
                    |> InternalPath.addCollection ".dicts"
                    |> InternalPath.validate
                    |> Expect.err
        , Test.test "ID contains over 1500 bytes is invalid" <|
            \_ ->
                InternalPath.new
                    |> InternalPath.addCollection "users"
                    |> InternalPath.addDocument (String.repeat 1500 "u" ++ "1")
                    |> InternalPath.validate
                    |> Expect.err
        ]
