module Tests.Config exposing (suite)

import Expect
import Firestore.Config as Config
import Firestore.Internals.Path as InternalPath
import Test
import Url.Builder as UrlBuilder


suite : Test.Test
suite =
    Test.describe "config"
        [ Test.test "endpoint" <|
            \_ ->
                { project = "test-project"
                }
                    |> Config.new
                    |> Config.withAPIKey "test-apiKey"
                    |> Config.endpoint
                        [ UrlBuilder.int "pageSize" 10
                        , UrlBuilder.string "orderBy" "name"
                        ]
                        (InternalPath.new
                            |> InternalPath.addCollection "users"
                            |> InternalPath.addDocument "user1"
                            |> Config.Path
                        )
                    |> Expect.equal "https://firestore.googleapis.com/v1/projects/test-project/databases/(default)/documents/users/user1?pageSize=10&orderBy=name&key=test-apiKey"
        ]
