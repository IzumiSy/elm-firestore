module Firestore.Decoder exposing (Document, Error, ErrorInfo, Response, document, response)

import Dict
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


{-|

@docs Response, Document, Error, ErrorInfo

-}



{- responseDeconder is being exposed, but this it only for unit testing -}


type alias Response a =
    { documents : List (Document a)
    }


response : Decode.Decoder a -> Decode.Decoder (Response a)
response fieldDecoder =
    Decode.succeed Response
        |> Pipeline.required "documents" (Decode.list (document fieldDecoder))


type alias Document a =
    { name : String
    , fields : Dict.Dict String a
    , createTime : String
    , updateTime : String
    }


document : Decode.Decoder a -> Decode.Decoder (Document a)
document fieldDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" (Decode.dict fieldDecoder)
        |> Pipeline.required "createTime" Decode.string
        |> Pipeline.required "updateTime" Decode.string


type alias Error =
    { code : ErrorInfo
    }


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.succeed Error
        |> Pipeline.required "error" errorInfoDecoder


type alias ErrorInfo =
    { code : Int
    , message : String
    , status : String
    }


errorInfoDecoder : Decode.Decoder ErrorInfo
errorInfoDecoder =
    Decode.succeed ErrorInfo
        |> Pipeline.required "code" Decode.int
        |> Pipeline.required "message" Decode.string
        |> Pipeline.required "status" Decode.string
