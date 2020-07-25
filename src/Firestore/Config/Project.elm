module Firestore.Config.Project exposing
    ( Project, new
    , toString
    )

{-| An opaque type to identify Firestore project to connect to

@docs Project, new

-}


type Project
    = Project String


{-| Accepts Firestore project ID as String
-}
new : String -> Project
new =
    Project


{-| -}
toString : Project -> String
toString (Project value) =
    value
