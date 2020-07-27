module Firestore.Internals.Draft exposing
    ( Draft
    , encode
    , new
    )

import Firestore.Internals.Field as Field
import Json.Encode as Encode


type Draft
    = Draft (List ( String, Field.Field ))


new : List ( String, Field.Field ) -> Draft
new =
    Draft


encode : Draft -> Encode.Value
encode (Draft fields) =
    Encode.object
        [ ( "fields"
          , fields
                |> List.map (\( key, field ) -> ( key, Field.unwrap field ))
                |> Encode.object
          )
        ]
