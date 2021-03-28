module Firestore.Codec exposing
    ( Codec, asEncoder, encode, asDecoder, decode
    , Document, document, build, required, optional
    , Field, bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    , map, andThen, succeed, fail, construct
    )

{-| Codec for Firestore

@docs Codec, asEncoder, encode, asDecoder, decode


# Constructors

@docs Document, document, build, required, optional


# Field

@docs Field, bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference


# Advanced

@docs map, andThen, succeed, fail, construct

-}

import Dict exposing (Dict)
import Firestore.Decode as Decode exposing (Decoder)
import Firestore.Encode as Encode exposing (Encoder)
import Firestore.Types.Geopoint exposing (Geopoint)
import Firestore.Types.Reference exposing (Reference)
import Json.Decode as D
import Json.Encode as E
import Time exposing (Posix)


{-| -}
type Codec a
    = Codec (Decoder a) (a -> Encoder)


{-| -}
asEncoder : Codec a -> (a -> Encoder)
asEncoder (Codec _ out) =
    out


{-| -}
asDecoder : Codec a -> Decoder a
asDecoder (Codec out _) =
    out


{-| -}
encode : Codec a -> a -> E.Value
encode codec =
    asEncoder codec
        >> Encode.encode


{-| -}
decode : Codec a -> D.Decoder a
decode =
    asDecoder
        >> Decode.decode



-- Constructors


{-| -}
type Document a cons
    = Document (Decoder cons) (a -> Dict String Encode.Field)


{-| -}
document : cons -> Document a cons
document fun =
    Document (Decode.document fun) (always Dict.empty)


{-| -}
build : Document a a -> Codec a
build (Document d e) =
    Codec d (e >> Encode.document)


{-| -}
required : String -> (a -> b) -> Field b -> Document a (b -> cons) -> Document a cons
required name getter (Field dField eField) (Document d e) =
    Document
        (Decode.required name dField d)
        (\value -> Dict.insert name (getter value |> eField) (e value))


{-| -}
optional : String -> (a -> b) -> Field b -> b -> Document a (b -> cons) -> Document a cons
optional name getter (Field dField eField) default (Document d e) =
    Document
        (Decode.optional name dField default d)
        (\value -> Dict.insert name (getter value |> eField ) (e value))



-- Field


{-| -}
type Field a
    = Field (Decode.Field a) (a -> Encode.Field)


{-| -}
bool : Field Bool
bool =
    Field Decode.bool Encode.bool


{-| -}
bytes : Field String
bytes =
    Field Decode.bytes Encode.bytes


{-| -}
int : Field Int
int =
    Field Decode.int Encode.int


{-| -}
string : Field String
string =
    Field Decode.string Encode.string


{-| -}
list : Field a -> Field (List a)
list (Field d e) =
    Field (Decode.list d) (Encode.list e)


{-| -}
dict : Field a -> Field (Dict String a)
dict (Field d e) =
    Field (Decode.dict d) (Encode.dict e)


{-| -}
null : Field ()
null =
    Field Decode.null (always Encode.null)


{-| -}
maybe : Field a -> Field (Maybe a)
maybe (Field d e) =
    Field (Decode.maybe d) (Encode.maybe e)


{-| -}
timestamp : Field Posix
timestamp =
    Field Decode.timestamp Encode.timestamp


{-| -}
geopoint : Field Geopoint
geopoint =
    Field Decode.geopoint Encode.geopoint


{-| -}
reference : Field Reference
reference =
    Field Decode.reference Encode.reference



-- Advanced


{-| -}
map : (a -> b) -> (b -> a) -> Field a -> Field b
map to from (Field d e) =
    Field (d |> Decode.map to)
        (from >> e)


{-| -}
andThen : (a -> Field b) -> (b -> a) -> Field a -> Field b
andThen to from (Field d e) =
    Field
        (d
            |> Decode.andThen
                (\a ->
                    let
                        (Field dField _) =
                            to a
                    in
                    dField
                )
        )
        (from >> e)


{-| -}
succeed : a -> Field a
succeed default =
    Field (Decode.succeed default)
        (always Encode.null)


{-| -}
fail : String -> Field a
fail msg =
    Field (Decode.fail msg)
        (always Encode.null)


{-| -}
construct : Decoder a -> (a -> Encoder) -> Codec a
construct d e =
    Codec d e
