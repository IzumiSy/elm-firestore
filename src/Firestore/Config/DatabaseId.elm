module Firestore.Config.DatabaseId exposing
    ( DatabaseId, new, default
    , unwrap
    )

{-| An opaque type to identify Firestore database ID

@docs DatabaseId, new, default

-}


type DatabaseId
    = DatabaseId String


new : String -> DatabaseId
new =
    DatabaseId


{-| This function is available in using default database ID instead of `new` function
-}
default : DatabaseId
default =
    DatabaseId "(default)"


unwrap : DatabaseId -> String
unwrap (DatabaseId value) =
    value
