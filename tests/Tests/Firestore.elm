module Tests.Firestore exposing (suite)

import Dict
import Expect
import Firestore.Decode as FSDecode
import Firestore.Encode as FSEncode
import Firestore.Internals as Internals
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Json.Decode as Decode
import Test
import Time


type alias Document =
    { timestamp : Time.Posix
    , reference : Reference.Reference
    , geopoint : Geopoint.Geopoint
    , integer : Int
    , string : String
    , list : List String
    , map : Dict.Dict String String
    , boolean : Bool
    , nullable : Maybe String
    }


documentDecoder : FSDecode.Decoder Document
documentDecoder =
    FSDecode.document Document
        |> FSDecode.required "timestamp" FSDecode.timestamp
        |> FSDecode.required "reference" FSDecode.reference
        |> FSDecode.required "geopoint" FSDecode.geopoint
        |> FSDecode.required "integer" FSDecode.int
        |> FSDecode.required "string" FSDecode.string
        |> FSDecode.required "list" (FSDecode.list FSDecode.string)
        |> FSDecode.required "map" (FSDecode.dict FSDecode.string)
        |> FSDecode.required "boolean" FSDecode.bool
        |> FSDecode.required "nullable" (FSDecode.maybe FSDecode.string)


type PageToken
    = PageToken String


type Name
    = Name Internals.Name


suite : Test.Test
suite =
    Test.describe "firestore"
        [ Test.test "decoder" <|
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
    ],
    "nextPageToken": "token"
  }
                      """
                in
                src
                    |> Decode.decodeString (Internals.decodeList Name PageToken documentDecoder)
                    |> Expect.ok
        , Test.test "encoder" <|
            \_ ->
                FSEncode.new
                    |> FSEncode.field "timestamp" (FSEncode.timestamp <| Time.millisToPosix 100)
                    |> FSEncode.field "reference" (FSEncode.reference <| Reference.new "aaa/bbb")
                    |> FSEncode.field "geopoint" (FSEncode.geopoint <| Geopoint.new { latitude = 10, longitude = 10 })
                    |> FSEncode.field "list" (FSEncode.list FSEncode.string [ "111", "222", "333" ])
                    |> FSEncode.field "map" (FSEncode.dict FSEncode.string (Dict.fromList [ ( "key1", "aaa" ), ( "key2", "bbb" ), ( "key3", "ccc" ) ]))
                    |> FSEncode.field "boolean" (FSEncode.bool True)
                    |> FSEncode.field "string" (FSEncode.string "IzumiSy")
                    |> FSEncode.field "integer" (FSEncode.int 99)
                    |> FSEncode.field "nullable" FSEncode.null
                    |> FSEncode.build
                    |> FSEncode.encode
                    |> Decode.decodeValue (FSDecode.decode documentDecoder)
                    |> Expect.ok
        ]
