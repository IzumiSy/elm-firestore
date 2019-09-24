module Firestore.Types.Reference exposing (Reference, new)

{-|

@docs Reference, new

-}


type Reference
    = Reference String


new : String -> Reference
new =
    Reference
