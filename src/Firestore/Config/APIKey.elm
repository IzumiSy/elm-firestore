module Firestore.Config.APIKey exposing
    ( APIKey, new
    , unwrap
    )

{-| An opaque type to identify APIKey

@docs APIKey, new

-}


{-| -}
type APIKey
    = APIKey String


{-| Creates a new API key from String
-}
new : String -> APIKey
new =
    APIKey


unwrap : APIKey -> String
unwrap (APIKey value) =
    value
