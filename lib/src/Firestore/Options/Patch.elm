module Firestore.Options.Patch exposing
    ( Options, empty, queryParameters
    , addUpdate, addDelete
    )

{-| An option type for `patch` operation.

@docs Options, empty, queryParameters


# Operations

@docs addUpdate, addDelete

-}

import Dict
import Firestore.Encode as FSEncode
import Set
import Url.Builder as UrlBuilder


{-| An option type for Patch operation
-}
type Options
    = Options
        { updates : Set.Set String
        , updateFields : Dict.Dict String FSEncode.Field
        , deletes : Set.Set String
        }


{-| Constructs options for patch operation
-}
empty : Options
empty =
    Options
        { updates = Set.empty
        , updateFields = Dict.empty
        , deletes = Set.empty
        }


{-| Adds a field to update
-}
addUpdate : String -> FSEncode.Field -> Options -> Options
addUpdate path field (Options options) =
    Options
        { options
            | updates = Set.insert path options.updates
            , updateFields = Dict.insert path field options.updateFields
        }


{-| Adds a field to delete
-}
addDelete : String -> Options -> Options
addDelete path (Options options) =
    Options { options | deletes = Set.insert path options.deletes }


{-| Converts options into query parameters
-}
queryParameters : Options -> ( List UrlBuilder.QueryParameter, List ( String, FSEncode.Field ) )
queryParameters (Options options) =
    ( List.concat
        [ Set.toList options.updates |> List.map (UrlBuilder.string "updateMask.fieldPaths")
        , Set.toList options.deletes |> List.map (UrlBuilder.string "updateMask.fieldPaths")
        ]
    , Dict.toList options.updateFields
    )
