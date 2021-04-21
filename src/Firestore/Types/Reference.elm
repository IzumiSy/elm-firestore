module Firestore.Types.Reference exposing (Reference, new, toString)

{-| Reference data type for Firestore

@docs Reference, new, toString

-}


{-| -}
type Reference
    = Reference String


{-| -}
new : String -> Reference
new =
    Reference


{-| -}
toString : Reference -> String
toString (Reference value) =
    value
