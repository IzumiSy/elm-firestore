module Tests.Firestore exposing (suite)

import Dict
import Expect
import Firestore.Config as Config
import Firestore.Decode as FSDecode
import Firestore.Encode as FSEncode
import Firestore.Internals.Document as Document
import Firestore.Internals.Path as Path
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Test
import Time
import Url.Builder as UrlBuilder


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


type alias WriteDocument =
    { fields : Document }


type PageToken
    = PageToken String


writeDecoder : Decode.Decoder WriteDocument
writeDecoder =
    Decode.succeed WriteDocument
        |> Pipeline.required "fields" (FSDecode.decode documentDecoder)


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
                    |> Decode.decodeString (Document.decodeList PageToken documentDecoder)
                    |> Expect.ok
        , Test.test "encoder" <|
            \_ ->
                [ ( "timestamp", FSEncode.timestamp <| Time.millisToPosix 100 )
                , ( "reference", FSEncode.reference <| Reference.new "aaa/bbb" )
                , ( "geopoint", FSEncode.geopoint <| Geopoint.new { latitude = 10, longitude = 10 } )
                , ( "list", FSEncode.list FSEncode.string [ "111", "222", "333" ] )
                , ( "map", FSEncode.dict FSEncode.string (Dict.fromList [ ( "key1", "aaa" ), ( "key2", "bbb" ), ( "key3", "ccc" ) ]) )
                , ( "boolean", FSEncode.bool True )
                , ( "string", FSEncode.string "IzumiSy" )
                , ( "integer", FSEncode.int 99 )
                , ( "nullable", FSEncode.maybe Nothing )
                ]
                    |> FSEncode.document
                    |> FSEncode.encode
                    |> Decode.decodeValue writeDecoder
                    |> Expect.ok
        , Test.test "endpoint" <|
            \_ ->
                { apiKey = "test-apiKey"
                , project = "test-project"
                }
                    |> Config.new
                    |> Config.endpoint
                        [ UrlBuilder.int "pageSize" 10
                        , UrlBuilder.string "orderBy" "name"
                        ]
                        (Path.empty
                            |> Path.append "users"
                            |> Path.append "bookmarks"
                        )
                    |> Expect.equal "https://firestore.googleapis.com/v1beta1/projects/test-project/databases/(default)/documents/users/bookmarks?pageSize=10&orderBy=name&key=test-apiKey"
        ]
