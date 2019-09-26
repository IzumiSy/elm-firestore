module Firestore.Types.Geopoint exposing (Geopoint, decoder, latitude, longitude, encoder)

{-|

@docs Geopoint, decoder, latitude, longitude, encoder

-}

import Firestore.Documents.Field as Field
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode


type Geopoint
    = Geopoint Int Int


type alias Payload =
    { latitude : Int
    , longitude : Int
    }


decoder : Decode.Decoder Geopoint
decoder =
    Decode.succeed
        (\lat long -> Decode.succeed (Geopoint lat long))
        |> Pipeline.required "latitude" Decode.int
        |> Pipeline.required "longitude" Decode.int
        |> Pipeline.resolve
        |> Decode.field "geoPointValue"


encoder : Geopoint -> Field.Field
encoder (Geopoint lat long) =
    Field.new <|
        Encode.object
            [ ( "geoPointValue"
              , Encode.object
                    [ ( "latitude", Encode.int lat )
                    , ( "longitude", Encode.int long )
                    ]
              )
            ]


longitude : Geopoint -> Int
longitude (Geopoint _ long) =
    long


latitude : Geopoint -> Int
latitude (Geopoint lat _) =
    lat
