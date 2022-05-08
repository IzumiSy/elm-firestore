module Firestore.Internals.Types exposing
    ( Bool
    , Bytes
    , Dict
    , Geopoint
    , Int
    , List
    , Listable
    , Maybe
    , Null
    , Reference
    , String
    , Timestamp
    , ValidatedField(..)
    )

import Json.Encode as JsonEncode


{-| A field identifier witout a type tag

I crafted this for internal implementation for `Encode.Encoder`.
`Encode.Field` has a type tag for phantom typing so that is not sutiable to be used in a part of
implementation of `Encode.Encoder` because it requires users to set type variables every time.

-}
type ValidatedField
    = ValidatedField JsonEncode.Value



-- Type tags


type Allowed
    = Allowed


type Denied
    = Denied


type alias Listable a =
    { a | listable : Allowed }


type alias Bool =
    { listble : Allowed }


type alias Bytes =
    { listable : Allowed }


type alias Int =
    { listable : Allowed }


type alias String =
    { listable : Allowed }


type alias List =
    { listable : Denied }


type alias Dict =
    { listable : Allowed }


type alias Null =
    { listable : Allowed }


type alias Maybe =
    { listable : Allowed }


type alias Timestamp =
    { listable : Allowed }


type alias Geopoint =
    { listable : Allowed }


type alias Reference =
    { listable : Allowed }
