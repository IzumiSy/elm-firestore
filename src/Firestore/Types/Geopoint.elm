module Firestore.Types.Geopoint exposing (Geopoint, new, latitude, longitude)

{-| Geopoint data type for Firestore

@docs Geopoint, new, latitude, longitude

-}


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
