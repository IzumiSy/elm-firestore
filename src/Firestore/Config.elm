module Firestore.Config exposing
    ( Config
    , new, withAuthorization, withDatabase
    , endpoint, httpHeader
    )

{-| Configuration types for Firestore

@docs Config


# Constructors

@docs new, withAuthorization, withDatabase


# Extractors

@docs endpoint, httpHeader

-}

import Firestore.Internals.Path as Path
import Http
import Url.Builder as UrlBuilder


type APIKey
    = APIKey String


type Project
    = Project String


{-| Data type for Firestore configuration

This type internally has all information which is required to send requests to Firestore through REST API.

-}
type Config
    = Config APIKey Project Database (Maybe Authorization)


{-| Creates a new Config
-}
new : { apiKey : String, project : String } -> Config
new config =
    Config (APIKey config.apiKey) (Project config.project) (Database "(default)") Nothing


{-| Builds an endpoint string without path
-}
endpoint : List UrlBuilder.QueryParameter -> Path.Path -> Config -> String
endpoint params path (Config (APIKey apiKey_) (Project project) (Database database_) _) =
    String.append "https://firestore.googleapis.com" <|
        UrlBuilder.absolute
            [ "v1beta1/projects"
            , project
            , "databases"
            , database_
            , "documents"
            , Path.toString path
            ]
            (List.append params [ UrlBuilder.string "key" apiKey_ ])


-- Authorization


type Authorization
    = Authorization String


{-| Specifies Firebase Authorization token which can be obtained through [`firebase.User#getIdToken`][verify_token] method.

[verify_token]: https://firebase.google.com/docs/auth/admin/verify-id-tokens#web

-}
withAuthorization : String -> Config -> Config
withAuthorization value (Config apiKey_ project_ database_ _) =
    Config apiKey_ project_ database_ (Just <| Authorization value)


{-| Extracts authorization with bearer prefix as `Http.Header`.
-}
httpHeader : Config -> List Http.Header
httpHeader (Config _ _ _ maybeAuthorization) =
    maybeAuthorization
        |> Maybe.map (\(Authorization authorization) -> authorization)
        |> Maybe.map (Http.header "Bearer")
        |> Maybe.map List.singleton
        |> Maybe.withDefault []



-- Database


type Database
    = Database String


{-| Specifies database ID to connect to.
-}
withDatabase : String -> Config -> Config
withDatabase value (Config apiKey_ project_ _ authorization_) =
    Config apiKey_ project_ (Database value) authorization_
