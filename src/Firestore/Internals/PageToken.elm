module Firestore.Internals.PageToken exposing (PageToken, new, value)

{- Internal PageToken implementation

   This module is not expected to be exposed in order to disable constructing a new one by users.

-}


type PageToken
    = PageToken String


new : String -> PageToken
new =
    PageToken


value : PageToken -> String
value (PageToken value_) =
    value_
