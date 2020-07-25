module Firestore.Config.Authorization exposing
    ( Authorization, new
    , empty, headers
    )

{-| A module for Firebase Authorization token

@docs Authorization, new

-}

import Http


{-| -}
type Authorization
    = Authorization (Maybe String)


{-| Creates a new Authorization from String
-}
new : String -> Authorization
new value =
    Authorization (Just value)


{-| Initializes Authorization with an empty value.
-}
empty : Authorization
empty =
    Authorization Nothing


{-| Converts Authorization into `List Http.Header`. This function is aimed to be used for `Http.toTask`.
-}
headers : Authorization -> List Http.Header
headers (Authorization value) =
    value
        |> Maybe.map (Http.header "Bearer")
        |> Maybe.map List.singleton
        |> Maybe.withDefault []
