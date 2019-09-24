module Firestore.Transaction exposing
    ( Transaction, new
    , unwrap
    )

{-| An opaque type which identifies transaction ID

@docs Transaction, new

-}


type Transaction
    = Transaction String


new : String -> Transaction
new =
    Transaction


unwrap : Transaction -> String
unwrap (Transaction id) =
    id
