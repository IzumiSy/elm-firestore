module Firestore.Document.Fields exposing
    ( Fields, new
    , encode
    )

{-|

@docs Fields, new

-}

import Firestore.Document.Field as Field
import Json.Encode as Encode


type Fields
    = Fields (List ( String, Field.Field ))


new : List ( String, Field.Field ) -> Fields
new =
    Fields


encode : Fields -> Encode.Value
encode (Fields fields) =
    fields
        |> List.map (\( key, value ) -> ( key, Field.unwrap value ))
        |> Encode.object
