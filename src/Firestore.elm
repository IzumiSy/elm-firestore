module Firestore exposing
    ( Firestore, Response
    , configure, collection
    , get, patch, delete, begin, commit, query
    )

{-| A library to have your app interact with Firestore in Elm

@docs Firestore, Response

@docs configure, collection

@docs get, patch, delete, begin, commit, query

-}

import Dict
import Firestore.APIKey as APIKey exposing (APIKey)
import Firestore.DatabaseId as DatabaseId exposing (DatabaseId)
import Firestore.Path as Path exposing (Path)
import Firestore.ProjectId as ProjectId exposing (ProjectId)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import String.Interpolate as Interpolate
import Time


type Firestore
    = Firestore APIKey ProjectId DatabaseId Path


{-| Config record has all information which is required to send requests to Firestore through REST API
-}
type alias Config =
    { apiKey : APIKey
    , projectId : ProjectId
    , databaseId : DatabaseId
    }


{-| Builds a new Firestore connection with Config
-}
configure : Config -> Firestore
configure { apiKey, projectId, databaseId } =
    Firestore apiKey projectId databaseId Path.empty


{-| Drills down document paths with a specific path name
-}
collection : String -> Firestore -> Firestore
collection pathValue (Firestore apiKey projectId databaseId path) =
    Firestore apiKey projectId databaseId (Path.append pathValue path)



-- Request


{-| TODO: Http.Error must be converted into hand-crafted Firestore error wrapper
So here needs using Http.task and Task.attempt to change it into Cmd msg
-}
get : (Result Http.Error Response -> msg) -> Firestore -> Cmd msg
get msg (Firestore apiKey projectId databaseId path) =
    Http.request
        { method = "GET"
        , headers = []
        , url =
            Interpolate.interpolate
                "https://firestore.googleapis.com/v1beta1/projects/{0}/databases/{1}/documents/{2}?key={3}"
                [ ProjectId.unwrap projectId
                , DatabaseId.unwrap databaseId
                , Path.toString path
                , APIKey.unwrap apiKey
                ]
        , body = Http.emptyBody
        , expect = Http.expectJson msg responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


patch : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
patch _ _ =
    Cmd.none


delete : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
delete _ _ =
    Cmd.none


begin : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
begin _ _ =
    Cmd.none


commit : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
commit _ _ =
    Cmd.none


query : Firestore -> (Result Http.Error () -> msg) -> Cmd msg
query _ _ =
    Cmd.none



-- Decoder


type alias Response =
    { documents : List Document
    }


responseDecoder : Decode.Decoder Response
responseDecoder =
    Decode.succeed Response
        |> Pipeline.required "documents" (Decode.list documentDecoder)


type alias Document =
    { name : String
    , fields : Dict.Dict String (Dict.Dict String String)
    , createTime : String
    , updateTime : String
    }


documentDecoder : Decode.Decoder Document
documentDecoder =
    Decode.succeed Document
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fields" (Decode.dict (Decode.dict Decode.string))
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
