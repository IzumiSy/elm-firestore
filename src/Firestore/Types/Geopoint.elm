module Firestore.Types.Geopoint exposing
    ( Geopoint, new, latitude, longitude
    , encode, decode
    )

{-| Geopoint data type for Firestore

@docs Geopoint, new, latitude, longitude

@docs encode, decode

-}

import Firestore.Internals.Field as Field
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode


{-| -}
type Geopoint
    = Geopoint Int Int


{-| -}
new : { latitude : Int, longitude : Int } -> Geopoint
new payload =
    Geopoint payload.latitude payload.longitude


{-| -}
longitude : Geopoint -> Int
longitude (Geopoint _ long) =
    long


{-| -}
latitude : Geopoint -> Int
latitude (Geopoint lat _) =
    lat


{-| -}
decode : Decode.Decoder Geopoint
decode =
    Decode.succeed
        (\lat long -> Decode.succeed (Geopoint lat long))
        |> Pipeline.required "latitude" Decode.int
        |> Pipeline.required "longitude" Decode.int
        |> Pipeline.resolve
        |> Decode.field "geoPointValue"


{-| -}
encode : Geopoint -> Field.Field
encode (Geopoint lat long) =
    Field.field <|
        Encode.object
            [ ( "geoPointValue"
              , Encode.object
                    [ ( "latitude", Encode.int lat )
                    , ( "longitude", Encode.int long )
                    ]
              )
            ]
