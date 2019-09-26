module Firestore.Document.Field exposing (Field, new, unwrap)

{-| Field is the opaque type which identifies Encode.Value as the valid data for Firestore field.
-}

import Json.Encode as Encode


type Field
    = Field Encode.Value


new : Encode.Value -> Field
new =
    Field


unwrap : Field -> Encode.Value
unwrap (Field value) =
    value
