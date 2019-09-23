module Firestore.APIKey exposing
    ( APIKey
    , new
    , unwrap
    )


type APIKey
    = APIKey String


new : String -> APIKey
new =
    APIKey


unwrap : APIKey -> String
unwrap (APIKey value) =
    value
