module Tests.Firestore exposing (suite)

import Expect
import Firestore
import Firestore.Types as Types
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Test


type alias Result =
    { created_at : String
    , location : Types.GeoPoint
    , bookmark : String
    , age : Int
    , name : String
    , items : List String
    , has_license : Bool
    , girlfriend : Maybe String
    }


decoder : Decode.Decoder Result
decoder =
    Decode.succeed Result
        |> Pipeline.required "created_at" Types.timestamp
        |> Pipeline.required "location" Types.geopoint
        |> Pipeline.required "bookmark" Types.reference
        |> Pipeline.required "age" Types.int
        |> Pipeline.required "name" Types.string
        |> Pipeline.required "items" (Types.list Types.string)
        |> Pipeline.required "has_license" Types.bool
        |> Pipeline.required "girlfriend" (Types.null Types.string)


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
                |> Decode.decodeString (Firestore.responseDecoder decoder)
                |> Expect.equal
                    (Ok
                        { documents =
                            [ { createTime = "2019-09-23T18:13:38.231211Z"
                              , fields =
                                    { age = 22
                                    , bookmark = "projects/elm-firestore-app/databases/(default)/documents/bookmarks/VBz8MMTEG2Dn3JWmTjVQ"
                                    , created_at = "2019-09-23T15:00:00Z"
                                    , girlfriend = Nothing
                                    , has_license = True
                                    , items = [ "hoge", "piyo" ]
                                    , location =
                                        { latitude = 10
                                        , longitude = 10
                                        }
                                    , name = "justine"
                                    }
                              , name = "projects/elm-firestore-app/databases/(default)/documents/users/Fa9yNDcFRNo8RaPnRvcz"
                              , updateTime = "2019-09-24T02:54:05.121725Z"
                              }
                            ]
                        }
                    )
