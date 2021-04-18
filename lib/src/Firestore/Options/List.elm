module Firestore.Options.List exposing
    ( Options, PageToken(..), default, queryParameters
    , pageToken, pageSize
    , OrderBy(..), orderBy
    )

{-| A type to define `list` operation parameters

@docs Options, PageToken, default, queryParameters

@docs pageToken, pageSize

@docs OrderBy, orderBy

-}

import Firestore.Internals as Internals
import Url.Builder as UrlBuilder


{-| An option type for List operation
-}
type Options
    = Options
        { pageSize : Maybe Int
        , orderBy : List OrderBy
        , pageToken : Maybe PageToken
        }


{-| Constructs options for list operation
-}
default : Options
default =
    Options
        { pageSize = Nothing
        , orderBy = []
        , pageToken = Nothing
        }


{-| Sets the maximum number of documents to return
-}
pageSize : Int -> Options -> Options
pageSize size (Options options) =
    Options { options | pageSize = Just size }


{-| Converts options into query parameters
-}
queryParameters : Options -> List UrlBuilder.QueryParameter
queryParameters (Options options) =
    let
        orderBy_ =
            options.orderBy
                |> List.foldl
                    (\c acc ->
                        case ( c, acc ) of
                            ( Desc value, Nothing ) ->
                                Just (value ++ " desc")

                            ( Desc value, Just s ) ->
                                Just (s ++ ", " ++ value ++ " desc")

                            ( Asc value, Nothing ) ->
                                Just (value ++ " asc")

                            ( Asc value, Just s ) ->
                                Just (s ++ ", " ++ value ++ " asc")
                    )
                    Nothing
    in
    List.filterMap identity <|
        [ Maybe.map (UrlBuilder.int "pageSize") options.pageSize
        , Maybe.map (UrlBuilder.string "orderBy") orderBy_
        , options.pageToken
            |> Maybe.map (\(PageToken (Internals.PageToken value)) -> value)
            |> Maybe.map (UrlBuilder.string "pageToken")
        ]


{-| The next page token.

This token is required in fetching the next result offset by `pageSize` in `list` operation.
The internal implementation is intetentionally encapsulated in order not to make invalid one by hand.
It can be obtained only from `Documents` record.

-}
type PageToken
    = PageToken Internals.PageToken


{-| Sets the page token obtained the previous List operation, if any.
-}
pageToken : PageToken -> Options -> Options
pageToken token (Options options) =
    Options { options | pageToken = Just token }


{-| OrderBy direction and column
-}
type OrderBy
    = Desc String
    | Asc String


{-| Sets order to sort results by
-}
orderBy : OrderBy -> Options -> Options
orderBy value (Options options) =
    Options { options | orderBy = value :: options.orderBy }
