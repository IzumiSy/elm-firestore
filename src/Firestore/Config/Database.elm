module Firestore.Config.Database exposing
    ( Database, new, default
    , toString
    )

{-| An opaque type to idenfity Firestore database to connect to

@docs Database, new, default

@docs toString

-}


type Database
    = Database String


{-| Accepts Firestore database ID as String
-}
new : String -> Database
new =
    Database


{-| Specifies database as a default
-}
default : Database
default =
    Database "(default)"


{-| -}
toString : Database -> String
toString (Database id) =
    id
