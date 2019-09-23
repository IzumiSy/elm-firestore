module Firestore.DatabaseId exposing
    ( DatabaseId
    , new
    , unwrap
    )


type DatabaseId
    = DatabaseId String


new : String -> DatabaseId
new =
    DatabaseId


unwrap : DatabaseId -> String
unwrap (DatabaseId value) =
    value
