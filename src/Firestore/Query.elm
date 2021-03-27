module Firestore.Query exposing
    ( Query, new, value
    , select
    , where_, Op(..), fieldFilter
    )

{-|

@docs Query, new, value

@docs select

@docs where_, Op, fieldFilter

-}

import Firestore.Encode as FSEncode
import Json.Encode as Encode


type Query
    = Query
        { where_ : Maybe Where
        , select : Maybe Select
        }


new : Query
new =
    Query
        { where_ = Nothing
        , select = Nothing
        }


value : Query -> Encode.Value
value (Query query) =
    -- Encode.null
    Encode.object
        [ ( "where"
          , case query.where_ of
                Just (FieldFilter fieldPath op _) ->
                    Encode.object
                        [ ( "op", opValue op )
                        , ( "field"
                          , Encode.object
                                [ ( "fieldPath", Encode.string fieldPath )
                                ]
                          )
                        ]

                Nothing ->
                    Encode.object []
          )
        ]


{-| Filter type.

    TODO: Support of CompositeFilter and UnaryFilter

-}
type Where
    = FieldFilter String Op FSEncode.Field


{-| Filter operation.

    TODO: Support of array-related operations (eg, NotIn, In, etc...)

-}
type Op
    = LessThan
    | LessThanOrEqual
    | GreaterThan
    | GreaterThanOrEqual
    | Equal
    | NotEqual


where_ : Where -> Query -> Query
where_ value_ (Query query) =
    Query { query | where_ = Just value_ }


fieldFilter : String -> Op -> FSEncode.Field -> Where
fieldFilter =
    FieldFilter


type Select
    = Select


select : Select -> Query -> Query
select value_ (Query query) =
    Query { query | select = Just value_ }



-- Internals


opValue : Op -> Encode.Value
opValue op =
    Encode.string <|
        case op of
            LessThan ->
                "LESS_THAN"

            LessThanOrEqual ->
                "LESS_THAN_OR_EQUAL"

            GreaterThan ->
                "GREATER_THAN"

            GreaterThanOrEqual ->
                "GREATER_THAN_OR_EQUAL"

            Equal ->
                "EQUAL"

            NotEqual ->
                "NOT_EQUAL"
