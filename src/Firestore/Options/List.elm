module Firestore.Options.List exposing
    ( Options, default, queryParameters
    , pageToken, orderBy, pageSize
    )

{-| A type to define `list` operation parameters

@docs Options, default, queryParameters

@docs pageToken, orderBy, pageSize

-}

import Firestore.Internals.PageToken as PageToken exposing (PageToken)
import Url.Builder as UrlBuilder


type Options
    = Options
        { pageSize : Maybe Int
        , orderBy : Maybe String
        , pageToken : Maybe PageToken
        }


{-| Construts options for list operation
-}
default : Options
default =
    Options
        { pageSize = Nothing
        , orderBy = Nothing
        , pageToken = Nothing
        }


pageToken : PageToken -> Options -> Options
pageToken token (Options options) =
    Options { options | pageToken = Just token }


pageSize : Int -> Options -> Options
pageSize size (Options options) =
    Options { options | pageSize = Just size }


orderBy : String -> Options -> Options
orderBy column (Options options) =
    Options { options | orderBy = Just column }


queryParameters : Options -> List UrlBuilder.QueryParameter
queryParameters (Options options) =
    List.filterMap identity <|
        [ Maybe.map (UrlBuilder.int "pageSize") options.pageSize
        , Maybe.map (UrlBuilder.string "orderBy") options.orderBy
        , options.pageToken
            |> Maybe.map PageToken.value
            |> Maybe.map (UrlBuilder.string "pageToken")
        ]
