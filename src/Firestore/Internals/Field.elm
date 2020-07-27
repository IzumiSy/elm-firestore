module Firestore.Internals.Field exposing
    ( Field
    , field
    , unwrap
    )

import Json.Encode as Encode


type Field
    = Field Encode.Value


field : Encode.Value -> Field
field =
    Field


unwrap : Field -> Encode.Value
unwrap (Field value) =
    value
