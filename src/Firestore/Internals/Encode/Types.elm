module Firestore.Internals.Encode.Types exposing
    ( Bool
    , Bytes
    , CanBeListElement
    , Dict
    , Geopoint
    , Int
    , List
    , Maybe
    , Null
    , Reference
    , String
    , Timestamp
    )


type alias CanBeListElement a =
    { a | canBeListElement : Allowed }


type alias Bool =
    { listble : Allowed }


type alias Bytes =
    { canBeListElement : Allowed }


type alias Int =
    { canBeListElement : Allowed }


type alias String =
    { canBeListElement : Allowed }


type alias List =
    { canBeListElement : NotAllowed }


type alias Dict =
    { canBeListElement : Allowed }


type alias Null =
    { canBeListElement : Allowed }


type alias Maybe =
    { canBeListElement : Allowed }


type alias Timestamp =
    { canBeListElement : Allowed }


type alias Geopoint =
    { canBeListElement : Allowed }


type alias Reference =
    { canBeListElement : Allowed }



-- Type tag


type Allowed
    = Allowed


type NotAllowed
    = NotAllowed
