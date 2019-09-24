module Firestore.ProjectId exposing
    ( ProjectId, new
    , unwrap
    )

{-| An opaque type to identify Firestore project ID

@docs ProjectId, new

-}


type ProjectId
    = ProjectId String


new : String -> ProjectId
new =
    ProjectId


unwrap : ProjectId -> String
unwrap (ProjectId value) =
    value
