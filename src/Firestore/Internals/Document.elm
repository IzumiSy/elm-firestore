module Firestore.Internals.Document exposing
    ( Document
    , decodeList
    , decodeOne
    )

import Firestore.Decode as FSDecode
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


decodeList : FSDecode.Decoder a -> Decode.Decoder (List (Document a))
decodeList fieldDecoder =
    Decode.succeed identity
        |> Pipeline.required "documents" (fieldDecoder |> decodeOne |> Decode.list)


decodeOne : FSDecode.Decoder a -> Decode.Decoder (Document a)
decodeOne fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" (FSDecode.decode fieldDecoder)
        |> Pipeline.required "createTime" Iso8601.decoder
        |> Pipeline.required "updateTime" Iso8601.decoder
