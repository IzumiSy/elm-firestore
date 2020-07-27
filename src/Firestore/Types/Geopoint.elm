module Firestore.Types.Geopoint exposing (Geopoint, decoder, latitude, longitude, encoder, new)

{-| Geopoint data type for Firestore

@docs Geopoint, decoder, latitude, longitude, encoder, new

-}

import Firestore.Document as Document
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode


{-| -}
type Geopoint
    = Geopoint Int Int


type alias Payload =
    { latitude : Int
    , longitude : Int
    }


{-| -}
new : Payload -> Geopoint
new payload =
    Geopoint payload.latitude payload.longitude


{-| -}
decoder : Decode.Decoder Geopoint
decoder =
    Decode.succeed
        (\lat long -> Decode.succeed (Geopoint lat long))
        |> Pipeline.required "latitude" Decode.int
        |> Pipeline.required "longitude" Decode.int
        |> Pipeline.resolve
        |> Decode.field "geoPointValue"


{-| -}
encoder : Geopoint -> Document.Field
encoder (Geopoint lat long) =
    Document.field <|
        Encode.object
            [ ( "geoPointValue"
              , Encode.object
                    [ ( "latitude", Encode.int lat )
                    , ( "longitude", Encode.int long )
                    ]
              )
            ]


{-| -}
longitude : Geopoint -> Int
longitude (Geopoint _ long) =
    long


{-| -}
latitude : Geopoint -> Int
latitude (Geopoint lat _) =
    lat
