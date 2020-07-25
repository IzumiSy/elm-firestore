module Firestore.Config.Authorization exposing
    ( Authorization, new, empty
    , headers
    )

{-| A module for Firebase Authorization token

@docs Authorization, new, empty

@docs headers

-}

import Http


type Authorization
    = Authorization (Maybe String)


new : String -> Authorization
new value =
    Authorization (Just value)


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
