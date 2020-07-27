module Tests.Firestore exposing (suite)

import Dict
import Expect
import Firestore.Internals.Document as Document
import Firestore.Internals.Draft as Draft
import Firestore.Types.Bool as FSBool
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Int as FSInt
import Firestore.Types.List as FSList
import Firestore.Types.Map as FSMap
import Firestore.Types.Nullable as FSNullable
import Firestore.Types.Reference as Reference
import Firestore.Types.String as FSString
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


documentDecoder : Decode.Decoder Document
documentDecoder =
    Decode.succeed Document
        |> Pipeline.required "timestamp" Timestamp.decoder
        |> Pipeline.required "reference" Reference.decoder
        |> Pipeline.required "geopoint" Geopoint.decoder
        |> Pipeline.required "integer" FSInt.decoder
        |> Pipeline.required "string" FSString.decoder
        |> Pipeline.required "list" (FSList.decoder FSString.decoder)
        |> Pipeline.required "map" (FSMap.decoder FSString.decoder)
        |> Pipeline.required "boolean" FSBool.decoder
        |> Pipeline.required "nullable" (FSNullable.decoder FSString.decoder)


type alias WriteDocument =
    { fields : Document }


writeDecoder : Decode.Decoder WriteDocument
writeDecoder =
    Decode.succeed WriteDocument
        |> Pipeline.required "fields" documentDecoder


suite : Test.Test
suite =
    Test.describe "firestore"
        [ Test.test "documentDecoder" <|
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
                    |> Decode.decodeString (Document.decodeList documentDecoder)
                    |> Expect.ok
        , Test.test "encoder" <|
            \_ ->
                [ ( "timestamp", Timestamp.encoder <| Timestamp.new <| Time.millisToPosix 100 )
                , ( "reference", Reference.encoder <| Reference.new "aaa/bbb" )
                , ( "geopoint", Geopoint.encoder <| Geopoint.new { latitude = 10, longitude = 10 } )
                , ( "list", FSList.encoder [ "111", "222", "333" ] FSString.encoder )
                , ( "map", FSMap.encoder (Dict.fromList [ ( "key1", "aaa" ), ( "key2", "bbb" ), ( "key3", "ccc" ) ]) FSString.encoder )
                , ( "boolean", FSBool.encoder True )
                , ( "string", FSString.encoder "IzumiSy" )
                , ( "integer", FSInt.encoder 99 )
                , ( "nullable", FSNullable.encoder Nothing )
                ]
                    |> Draft.new
                    |> Draft.encode
                    |> Decode.decodeValue writeDecoder
                    |> Expect.ok
        ]
