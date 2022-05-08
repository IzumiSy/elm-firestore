module Firestore.Options.Patch exposing
    ( Options, empty, queryParameters
    , addUpdate, addDelete
    )

{-| An option type for `patch` operation.

@docs Options, empty, queryParameters


# Operations

@docs addUpdate, addDelete

-}

import Firestore.Encode as FSEncode
import Set
import Url.Builder as UrlBuilder


{-| An option type for Patch operation
-}
type Options
    = Options
        { updates : Set.Set String
        , updatesBuilder : FSEncode.Builder
        , deletes : Set.Set String
        }


{-| Constructs options for patch operation
-}
empty : Options
empty =
    Options
        { updates = Set.empty
        , updatesBuilder = FSEncode.new
        , deletes = Set.empty
        }


{-| Adds a field to update
-}
addUpdate : String -> FSEncode.Field a -> Options -> Options
addUpdate path field (Options options) =
    Options
        { options
            | updates = Set.insert path options.updates
            , updatesBuilder = FSEncode.field path field options.updatesBuilder
        }


{-| Adds a field to delete
-}
addDelete : String -> Options -> Options
addDelete path (Options options) =
    Options { options | deletes = Set.insert path options.deletes }


{-| Converts options into query parameters
-}
queryParameters : Options -> ( List UrlBuilder.QueryParameter, FSEncode.Encoder )
queryParameters (Options options) =
    ( List.concat
        [ Set.toList options.updates |> List.map (UrlBuilder.string "updateMask.fieldPaths")
        , Set.toList options.deletes |> List.map (UrlBuilder.string "updateMask.fieldPaths")
        ]
    , FSEncode.build options.updatesBuilder
    )
