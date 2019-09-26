module Firestore.Document exposing (Document, decoder)

import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
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
