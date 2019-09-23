module Firestore.ProjectId exposing
    ( ProjectId
    , new
    , unwrap
    )


type ProjectId
    = ProjectId String


new : String -> ProjectId
new =
    ProjectId


unwrap : ProjectId -> String
unwrap (ProjectId value) =
    value
