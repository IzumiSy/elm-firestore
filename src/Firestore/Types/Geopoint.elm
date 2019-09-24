module Firestore.Types.Geopoint exposing (Geopoint, decoder, latitude, longitude)

{-|

@docs Geopoint, decoder, latitude, longitude

-}

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


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


longitude : Geopoint -> Int
longitude (Geopoint _ long) =
    long


latitude : Geopoint -> Int
latitude (Geopoint lat _) =
    lat
