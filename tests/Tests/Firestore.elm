module Tests.Firestore exposing (suite)

import Expect
import Firestore
import Json.Decode as Decode
import Test


suite : Test.Test
suite =
    Test.test "responseDecoder works fine" <|
        \_ ->
            let
                src =
                    """
{
  "documents": [
    {
      "name": "projects/elm-firestore-app/databases/(default)/documents/users/Fa9yNDcFRNo8RaPnRvcz",
      "fields": {
        "created_at": {
          "timestampValue": "2019-09-23T15:00:00Z"
        },
        "location": {
          "geoPointValue": {
            "latitude": 10,
            "longitude": 10
          }
        },
        "bookmark": {
          "referenceValue": "projects/elm-firestore-app/databases/(default)/documents/bookmarks/VBz8MMTEG2Dn3JWmTjVQ"
        },
        "age": {
          "integerValue": "22"
        },
        "name": {
          "stringValue": "justine"
        },
        "items": {
          "arrayValue": {
            "values": [
              {
                "stringValue": "hoge"
              },
              {
                "stringValue": "piyo"
              }
            ]
          }
        },
        "has_license": {
          "booleanValue": true
        },
        "girlfriend": {
          "nullValue": null
        }
      },
      "createTime": "2019-09-23T18:13:38.231211Z",
      "updateTime": "2019-09-24T02:54:05.121725Z"
    }
  ]
}
                    """
            in
            src
                |> Decode.decodeString Firestore.responseDecoder
                |> Expect.equal
                    (Ok
                        { documents = []
                        }
                    )
