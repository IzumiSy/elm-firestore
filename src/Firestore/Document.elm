module Firestore.Document exposing
    ( Document
    , Field
    , Fields
    , decodeList
    , decodeOne
    , encode
    , field
    , fields
    , unwrapField
    )

import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Time



-- Document


{-| A record strucutre for a document fetched from Firestore.

`fields` field is expected to be a record that consists of types coming from modules under `Firestore.Types` namespace.

-}
type alias Document a =
    { name : String
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


decodeList : Decode.Decoder a -> Decode.Decoder (List (Document a))
decodeList fieldDecoder =
    Decode.succeed identity
        |> Pipeline.required "documents" (fieldDecoder |> decodeOne |> Decode.list)


decodeOne : Decode.Decoder a -> Decode.Decoder (Document a)
decodeOne fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" fieldDecoder
        |> Pipeline.required "createTime" Iso8601.decoder
        |> Pipeline.required "updateTime" Iso8601.decoder


encode : Fields -> Encode.Value
encode (Fields fields_) =
    Encode.object
        [ ( "fields"
          , fields_
                |> List.map (\( key, Field value ) -> ( key, value ))
                |> Encode.object
          )
        ]



-- Field


type Field
    = Field Encode.Value


field : Encode.Value -> Field
field =
    Field


unwrapField : Field -> Encode.Value
unwrapField (Field value) =
    value



-- Fields


type Fields
    = Fields (List ( String, Field ))


fields : List ( String, Field ) -> Fields
fields =
    Fields
