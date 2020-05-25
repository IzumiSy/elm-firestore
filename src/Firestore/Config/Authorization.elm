module Firestore.Config.Authorization exposing
    ( Authorization
    , new, empty
    , header
    )

{-| A module for Firebase Authorization token

@docs Authorization

@docs new, empty

@docs header

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


header : Authorization -> Maybe Http.Header
header (Authorization value) =
    Maybe.map (Http.header "Bearer") value
