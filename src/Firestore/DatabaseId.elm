module Firestore.DatabaseId exposing
    ( DatabaseId
    , default
    , new
    , unwrap
    )


type DatabaseId
    = DatabaseId String


new : String -> DatabaseId
new =
    DatabaseId


default : DatabaseId
default =
    DatabaseId "(default)"


unwrap : DatabaseId -> String
unwrap (DatabaseId value) =
    value
