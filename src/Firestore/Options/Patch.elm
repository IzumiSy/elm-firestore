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
import Firestore.Internals.Tags as InternalTags
import Set
import Url.Builder as UrlBuilder


{-| An option type for Patch operation
-}
type Options a
    = Options
        { updates : Set.Set String
        , updatesBuilder : FSEncode.Builder a
        , deletes : Set.Set String
        }


{-| Constructs options for patch operation
-}
empty : Options InternalTags.Empty
empty =
    Options
        { updates = Set.empty
        , updatesBuilder = FSEncode.new
        , deletes = Set.empty
        }


{-| Adds a field to update
-}
addUpdate : String -> FSEncode.Field a -> Options InternalTags.Building -> Options InternalTags.Building
addUpdate path field (Options options) =
    Options
        { options
            | updates = Set.insert path options.updates
            , updatesBuilder = FSEncode.field path field options.updatesBuilder
        }


{-| Adds a field to delete
-}
addDelete : String -> Options a -> Options a
addDelete path (Options options) =
    Options { options | deletes = Set.insert path options.deletes }


{-| Converts options into query parameters
-}
queryParameters : Options InternalTags.Building -> ( List UrlBuilder.QueryParameter, FSEncode.Encoder )
queryParameters (Options options) =
    ( List.concat
        [ Set.toList options.updates |> List.map (UrlBuilder.string "updateMask.fieldPaths")
        , Set.toList options.deletes |> List.map (UrlBuilder.string "updateMask.fieldPaths")
        ]
    , FSEncode.build options.updatesBuilder
    )
