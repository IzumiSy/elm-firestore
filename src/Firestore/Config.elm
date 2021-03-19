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

import Http
import Typed exposing (Typed)
import Url.Builder as UrlBuilder


type alias APIKey =
    Typed APIKeyType String Typed.ReadWrite


type alias Project =
    Typed ProjectType String Typed.ReadWrite


{-| Data type for Firestore configuration

This type internally has all information which is required to send requests to Firestore through REST API.

-}
type Config
    = Config APIKey Project Database (Maybe Authorization)


{-| Creates a new Config
-}
new : { apiKey : String, project : String } -> Config
new config =
    Config (Typed.new config.apiKey) (Typed.new config.project) defaultDatabase Nothing


{-| Builds an endpoint string without path
-}
endpoint : List UrlBuilder.QueryParameter -> String -> Config -> String
endpoint params path (Config apiKey_ project (Database database_) _) =
    String.append "https://firestore.googleapis.com" <|
        UrlBuilder.absolute
            [ "v1beta1/projects"
            , Typed.value project
            , "databases"
            , Typed.value database_
            , "documents"
            , path
            ]
            (List.append params [ UrlBuilder.string "key" (Typed.value apiKey_) ])



-- Authorization


type alias Authorization =
    Typed AuthorizationType String Typed.ReadWrite


{-| Specifies Firebase Authorization token which can be obtained through [`firebase.User#getIdToken`][verify_token] method.

[verify_token]: https://firebase.google.com/docs/auth/admin/verify-id-tokens#web

-}
withAuthorization : String -> Config -> Config
withAuthorization value (Config apiKey_ project_ database_ _) =
    Config apiKey_ project_ database_ (Just <| Typed.new value)


{-| Extracts authorization with bearer prefix as `Http.Header`.
-}
httpHeader : Config -> List Http.Header
httpHeader (Config _ _ _ maybeAuthorization) =
    maybeAuthorization
        |> Maybe.map Typed.value
        |> Maybe.map (Http.header "Bearer")
        |> Maybe.map List.singleton
        |> Maybe.withDefault []



-- Database


type alias DatabaseID =
    Typed DatabaseIDType String Typed.ReadWrite


type Database
    = Database DatabaseID


{-| Specifies database ID to connect to.
-}
withDatabase : String -> Config -> Config
withDatabase value (Config apiKey_ project_ _ authorization_) =
    Config apiKey_ project_ (Database <| Typed.new value) authorization_



-- internals


type APIKeyType
    = APIKeyType


type ProjectType
    = ProjectType


type AuthorizationType
    = AuthorizationType


type DatabaseIDType
    = DatabaseIDType


defaultDatabase : Database
defaultDatabase =
    Database <| Typed.new "(default)"
