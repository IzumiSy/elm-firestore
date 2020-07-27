module Firestore.Config exposing
    ( Config, new, endpoint
    , withAuthorization, withDatabase, httpHeader
    )

{-| Configuration types for Firestore

@docs Config, new, endpoint

@docs withAuthorization, withDatabase

-}

import Http
import Template exposing (render, template, withString, withValue)


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
endpoint : String -> Config -> String
endpoint path (Config (APIKey apiKey_) (Project project) (Database database_) _) =
    template "https://firestore.googleapis.com/v1beta1/projects/"
        |> withValue .project
        |> withString "/databases/"
        |> withValue .database
        |> withString path
        |> withString "?key="
        |> withValue .apiKey
        |> render
            { project = project
            , database = database_
            , apiKey = apiKey_
            }



-- Authorization


type Authorization
    = Authorization String


{-| Specifies authorization header.
-}
withAuthorization : String -> Config -> Config
withAuthorization value (Config apiKey_ project_ database_ _) =
    Config apiKey_ project_ database_ (Just <| Authorization value)


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
