module Firestore.Query exposing
    ( Query, new, encode
    , offset, limit, from
    , Direction(..), orderBy
    , Where, FieldOp(..), UnaryOp(..), CompositeOp(..), compositeFilter, fieldFilter, unaryFilter, where_
    , Value, bool, int, string, timestamp
    )

{-|

@docs Query, new, encode

@docs offset, limit, from

@docs OrderBy, Direction, orderBy

@docs Where, FieldOp, UnaryOp, CompositeOp, compositeFilter, fieldFilter, unaryFilter, where_

@docs Value, bool, int, string, timestamp

-}

import Dict
import Firestore.Internals.Encode as Encode
import Json.Encode as JsonEncode
import Set
import Time
import Typed exposing (Typed)


{-| A data structure for query operation
-}
type Query
    = Query
        { where_ : Maybe Where
        , orderBy : OrderBy
        , offset : Maybe Int
        , limit : Maybe Int
        , from : From
        }


{-| Constructs an empty query
-}
new : Query
new =
    Query
        { where_ = Nothing
        , orderBy = Dict.empty
        , offset = Nothing
        , limit = Nothing
        , from = Set.empty
        }


{-| Encodes query
-}
encode : Query -> JsonEncode.Value
encode (Query query) =
    JsonEncode.object <|
        List.filterMap identity <|
            [ Just
                ( "where"
                , query.where_
                    |> Maybe.map whereValue
                    |> Maybe.withDefault (JsonEncode.object [])
                )
            , Just ( "orderBy", orderByValue query.orderBy )
            , Just ( "from", fromValue query.from )
            , Maybe.map (\value -> ( "offset", JsonEncode.int value )) query.offset
            , Maybe.map (\value -> ( "limit", JsonEncode.int value )) query.limit
            ]


{-| Sets the number of results to skip.
-}
offset : Int -> Query -> Query
offset value (Query query) =
    Query { query | offset = Just value }


{-| Sets the maximum number of results to return.
-}
limit : Int -> Query -> Query
limit value (Query query) =
    Query { query | limit = Just value }


type alias From =
    Set.Set String


from : String -> Query -> Query
from collection (Query query) =
    Query { query | from = Set.insert collection query.from }



-- OrderBy


{-| Currently elm-firestore does not support multiple field paths
-}
type alias OrderBy =
    Dict.Dict String Direction


{-| Ordering direction
-}
type Direction
    = Unspecified
    | Ascending
    | Descending


{-| Sets OrderBy value to query
-}
orderBy : String -> Direction -> Query -> Query
orderBy fieldPath direction (Query query) =
    Query { query | orderBy = Dict.insert fieldPath direction query.orderBy }



-- Where


type alias FieldPath =
    Typed FieldPathType String Typed.WriteOnly


{-| Where type.

    CompositeFilter requires at least one filter, so it has non-empty list like structure.

-}
type Where
    = CompositeFilter CompositeOp Where (List Where)
    | FieldFilter FieldPath FieldOp Value
    | UnaryFilter FieldPath UnaryOp


{-| Constructs CompositeFilter
-}
compositeFilter : CompositeOp -> Where -> List Where -> Where
compositeFilter =
    CompositeFilter


{-| Constructs FieldFilter
-}
fieldFilter : String -> FieldOp -> Value -> Where
fieldFilter fieldPath =
    FieldFilter (Typed.writeOnly fieldPath)


{-| Constructs UnaryFilter
-}
unaryFilter : String -> UnaryOp -> Where
unaryFilter fieldPath =
    UnaryFilter (Typed.writeOnly fieldPath)


{-| Operations for FieldFilter.

    TODO: Support of array-related operations (eg, NotIn, In, etc...)

-}
type FieldOp
    = LessThan
    | LessThanOrEqual
    | GreaterThan
    | GreaterThanOrEqual
    | Equal
    | NotEqual


{-| Oprations for UnaryFilter
-}
type UnaryOp
    = IsNaN
    | IsNull
    | IsNotNaN
    | IsNotNull


{-| Operations for CompositeFilter
-}
type CompositeOp
    = And


{-| Sets filter to query
-}
where_ : Where -> Query -> Query
where_ value_ (Query query) =
    Query { query | where_ = Just value_ }



-- Value


{-| A value type for querying operation
-}
type Value
    = Value JsonEncode.Value


{-| -}
bool : Bool -> Value
bool =
    Value << Encode.bool


{-| -}
int : Int -> Value
int =
    Value << Encode.int


{-| -}
string : String -> Value
string =
    Value << Encode.string


{-| -}
timestamp : Time.Posix -> Value
timestamp =
    Value << Encode.timestamp



-- Internals


type FieldPathType
    = FieldPathType


whereValue : Where -> JsonEncode.Value
whereValue where__ =
    case where__ of
        CompositeFilter op filter filters ->
            JsonEncode.object
                [ ( "compositeFilter"
                  , JsonEncode.object
                        [ ( "op", compositeOpValue op )
                        , ( "filters"
                          , JsonEncode.list whereValue (filter :: filters)
                          )
                        ]
                  )
                ]

        FieldFilter fieldPath op (Value value) ->
            JsonEncode.object
                [ ( "fieldFilter"
                  , JsonEncode.object
                        [ ( "op", fieldOpValue op )
                        , ( "field"
                          , JsonEncode.object
                                [ ( "fieldPath", Typed.encode JsonEncode.string fieldPath )
                                ]
                          )
                        , ( "value", value )
                        ]
                  )
                ]

        UnaryFilter fieldPath op ->
            JsonEncode.object
                [ ( "unaryFilter"
                  , JsonEncode.object
                        [ ( "op", unaryOpValue op )
                        , ( "field"
                          , JsonEncode.object
                                [ ( "fieldPath", Typed.encode JsonEncode.string fieldPath )
                                ]
                          )
                        ]
                  )
                ]


orderByValue : OrderBy -> JsonEncode.Value
orderByValue =
    Dict.toList
        >> JsonEncode.list
            (\( field, direction ) ->
                JsonEncode.object
                    [ ( "field", JsonEncode.object [ ( "fieldPath", JsonEncode.string field ) ] )
                    , ( "direction", directionValue direction )
                    ]
            )


fromValue : From -> JsonEncode.Value
fromValue =
    Set.toList
        >> JsonEncode.list
            (\value ->
                JsonEncode.object
                    [ ( "collectionId", JsonEncode.string value ) ]
            )


directionValue : Direction -> JsonEncode.Value
directionValue value =
    JsonEncode.string <|
        case value of
            Unspecified ->
                "DIRECTION_UNSPECIFIED"

            Ascending ->
                "ASCENDING"

            Descending ->
                "DESCENDING"


compositeOpValue : CompositeOp -> JsonEncode.Value
compositeOpValue op =
    JsonEncode.string <|
        case op of
            And ->
                "AND"


fieldOpValue : FieldOp -> JsonEncode.Value
fieldOpValue op =
    JsonEncode.string <|
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


unaryOpValue : UnaryOp -> JsonEncode.Value
unaryOpValue op =
    JsonEncode.string <|
        case op of
            IsNaN ->
                "IS_NAN"

            IsNull ->
                "IS_NULL"

            IsNotNaN ->
                "IS_NOT_NAN"

            IsNotNull ->
                "IS_NOT_NULL"
