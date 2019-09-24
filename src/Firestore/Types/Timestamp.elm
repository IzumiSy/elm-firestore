module Firestore.Types.Timestamp exposing (Timestamp, new)

{-|

@docs Timestamp, new

-}


type Timestamp
    = Timestamp String


new : String -> Timestamp
new =
    Timestamp
