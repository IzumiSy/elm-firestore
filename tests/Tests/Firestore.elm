module Tests.Firestore exposing (suite)

import Dict
import Expect
import Firestore
import Firestore.Types as Types
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Firestore.Types.Timestamp as Timestamp
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Test
import Time


type alias Document =
    { timestamp : Timestamp.Timestamp
    , reference : Reference.Reference
    , geopoint : Geopoint.Geopoint
    , integer : Int
    , string : String
    , list : List String
    , map : Dict.Dict String String
    , boolean : Bool
    , nullable : Maybe String
    }


decoder : Decode.Decoder Document
decoder =
    Decode.succeed Document
        |> Pipeline.required "timestamp" Types.timestamp
        |> Pipeline.required "reference" Types.reference
        |> Pipeline.required "geopoint" Types.geopoint
        |> Pipeline.required "integer" Types.int
        |> Pipeline.required "string" Types.string
        |> Pipeline.required "list" (Types.list Types.string)
        |> Pipeline.required "map" (Types.map Types.string)
        |> Pipeline.required "boolean" Types.bool
        |> Pipeline.required "nullable" (Types.null Types.string)


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
        "timestamp": {
          "timestampValue": "2019-09-24T15:00:00Z"
        },
        "geopoint": {
          "geoPointValue": {
            "latitude": 10,
            "longitude": 10
          }
        },
        "reference": {
          "referenceValue": "projects/elm-firestore-app/databases/(default)/documents/bookmarks/VBz8MMTEG2Dn3JWmTjVQ"
        },
        "list": {
          "arrayValue": {
            "values": [
              {
                "stringValue": "111"
              },
              {
                "stringValue": "222"
              },
              {
                "stringValue": "333"
              }
            ]
          }
        },
        "map": {
          "mapValue": {
            "fields": {
              "key1": {
                "stringValue": "aaa"
              },
              "key2": {
                "stringValue": "bbb"
              },
              "key3": {
                "stringValue": "ccc"
              }
            }
          }
        },
        "boolean": {
          "booleanValue": true
        },
        "string": {
          "stringValue": "IzumiSy"
        },
        "integer": {
          "integerValue": "99"
        },
        "nullable": {
          "nullValue": null
        }
      },
      "createTime": "2019-09-23T18:13:38.231211Z",
      "updateTime": "2019-09-24T14:10:55.934407Z"
    }
  ]
}

                    """
            in
            src
                |> Decode.decodeString (Firestore.responseDecoder decoder)
                |> Expect.ok
