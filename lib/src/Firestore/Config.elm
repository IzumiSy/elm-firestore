module Firestore.Config exposing
    ( Config
    , new, withAuthorization, withDatabase, withHost
    , endpoint, httpHeader
    )

{-| Configuration types for Firestore

@docs Config


# Constructors

@docs new, withAuthorization, withDatabase, withHost


# Extractors

@docs endpoint, httpHeader

-}

import Http
import Typed exposing (Typed)
import Url.Builder as UrlBuilder


type alias APIKey =
    Typed APIKeyType String Typed.ReadWrite


type alias ProjectId =
    Typed ProjectType String Typed.ReadWrite


type alias BaseUrl =
    Typed BaseUrlType String Typed.ReadWrite


{-| Data type for Firestore configuration

This type internally has all information which is required to send requests to Firestore through REST API.

-}
type Config
    = Config
        { apiKey : APIKey
        , project : ProjectId
        , database : DatabaseId
        , authorization : Maybe Authorization
        , baseUrl : BaseUrl
        }


{-| Creates a new Config
-}
new : { apiKey : String, project : String } -> Config
new config =
    Config
        { apiKey = Typed.new config.apiKey
        , project = Typed.new config.project
        , database = defaultDatabase
        , authorization = Nothing
        , baseUrl = Typed.new "https://firestore.googleapis.com"
        }


{-| Builds an endpoint string without path
-}
endpoint : List UrlBuilder.QueryParameter -> String -> Config -> String
endpoint params path (Config { apiKey, project, database, baseUrl }) =
    UrlBuilder.crossOrigin
        (Typed.value baseUrl)
        [ "v1beta1/projects"
        , Typed.value project
        , "databases"
        , Typed.value database
        , "documents"
        , path
        ]
        (List.append params [ UrlBuilder.string "key" (Typed.value apiKey) ])



-- Host


withHost : String -> Int -> Config -> Config
withHost host port_ (Config config) =
    Config { config | baseUrl = Typed.new (host ++ ":" ++ String.fromInt port_) }



-- Authorization


type alias Authorization =
    Typed AuthorizationType String Typed.ReadWrite


{-| Specifies Firebase Authorization token which can be obtained through [`firebase.User#getIdToken`][verify_token] method.

[verify_token]: https://firebase.google.com/docs/auth/admin/verify-id-tokens#web

-}
withAuthorization : String -> Config -> Config
withAuthorization value (Config config) =
    Config { config | authorization = Just <| Typed.new value }


{-| Extracts authorization with bearer prefix as `Http.Header`.
-}
httpHeader : Config -> List Http.Header
httpHeader (Config { authorization }) =
    authorization
        |> Maybe.map Typed.value
        |> Maybe.map (Http.header "Bearer")
        |> Maybe.map List.singleton
        |> Maybe.withDefault []



-- Database


type alias DatabaseId =
    Typed DatabaseIdType String Typed.ReadWrite


{-| Specifies database ID to connect to.
-}
withDatabase : String -> Config -> Config
withDatabase value (Config config) =
    Config { config | database = Typed.new value }



-- internals


type APIKeyType
    = APIKeyType


type ProjectType
    = ProjectType


type AuthorizationType
    = AuthorizationType


type BaseUrlType
    = BaseUrlType


type DatabaseIdType
    = DatabaseIdType


defaultDatabase : DatabaseId
defaultDatabase =
    Typed.new "(default)"