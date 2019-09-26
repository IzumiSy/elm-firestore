module Firestore.Document exposing
    ( Document
    , decoder, encode
    )

{-|

@docs Document

-}

import Firestore.Document.Fields as Fields
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Time


type alias Document a =
    { name : String
    , fields : a
    , createTime : Time.Posix
    , updateTime : Time.Posix
    }


decoder : Decode.Decoder a -> Decode.Decoder (Document a)
decoder fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" fieldDecoder
        |> Pipeline.required "createTime" Iso8601.decoder
        |> Pipeline.required "updateTime" Iso8601.decoder


encode : Fields.Fields -> Encode.Value
encode fields =
    Encode.object
        [ ( "fields", Fields.encode fields ) ]
