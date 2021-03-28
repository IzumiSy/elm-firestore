module Firestore.Query exposing
    ( Query, new, encode
    , select
    , where_, Op(..), fieldFilter
    , Value, bool, int, string, timestamp
    )

{-|

@docs Query, new, encode

@docs select

@docs where_, Op, fieldFilter

@docs Value, bool, int, string, timestamp

-}

import Firestore.Internals.Encode as Encode
import Json.Encode as JsonEncode
import Time


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


encode : Query -> JsonEncode.Value
encode (Query query) =
    let
        whereQuery =
            case query.where_ of
                Just (FieldFilter fieldPath op (Value value)) ->
                    JsonEncode.object
                        [ ( "op", opValue op )
                        , ( "field"
                          , JsonEncode.object
                                [ ( "fieldPath", JsonEncode.string fieldPath )
                                ]
                          )
                        , ( "value", value )
                        ]

                Nothing ->
                    JsonEncode.object []
    in
    JsonEncode.object
        [ ( "where", whereQuery )
        ]


{-| Filter type.

    TODO: Support of CompositeFilter and UnaryFilter

-}
type Where
    = FieldFilter String Op Value


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


fieldFilter : String -> Op -> Value -> Where
fieldFilter =
    FieldFilter


{-| Projection type
-}
type Select
    = Select


select : Select -> Query -> Query
select value_ (Query query) =
    Query { query | select = Just value_ }


{-| A predicate value for querying operation
-}
type Value
    = Value JsonEncode.Value


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


opValue : Op -> JsonEncode.Value
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
