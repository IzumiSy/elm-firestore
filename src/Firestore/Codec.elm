module Firestore.Codec exposing
    ( Codec, asEncoder, encode, asDecoder, decode
    , Document, document, build, required, optional
    , Field, bool, bytes, int, string, list, dict, null, maybe, timestamp, geopoint, reference
    , map, andThen, succeed, fail, construct
    )

{-| Codec for Firestore

    type alias User =
        { name : String
        , age : Int
        }

    codec : Codec.Codec User
    codec =
        Codec.document User
            |> Codec.required "name" .name Codec.string
            |> Codec.required "age" .age Codec.int
            |> Codec.build

    getDocument : Firestore.Firestore -> Cmd Msg
    getDocument firestore =
        firestore
            |> Firestore.root
            |> Firestore.collection "users"
            |> Firestore.document "user0"
            |> Firestore.build
            |> ExResult.toTask
            |> Task.andThen (Firestore.get (Codec.asDecoder codec))
            |> Task.attempt GotDocument

    insertDocument : Firestore.Firestore -> Cmd Msg
    insertDocument firestore =
        firestore
            |> Firestore.root
            |> Firestore.collection "users"
            |> Firestore.build
            |> ExResult.toTask
            |> Task.andThen
                (Firestore.insert
                    (Codec.asDecoder codec)
                    (Codec.asEncoder codec { name = "thomas", age = 26 })
                )
            |> Task.attempt InsertedDocument


# Definitions

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
import Firestore.Internals.Types as InternalTypes
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
    = Document (Decoder cons) (a -> List ( String, Encode.Field a ))


{-| -}
document : cons -> Document a cons
document fun =
    Document (Decode.document fun) (always [])


{-| -}
build : Document a a -> Codec a
build (Document d e) =
    Codec d (e >> Encode.document)


{-| -}
required : String -> (a -> b) -> Field b a -> Document a (b -> cons) -> Document a cons
required name getter (Field dField eField) (Document d e) =
    Document
        (Decode.required name dField d)
        (\value -> ( name, getter value |> eField ) :: e value)


{-| -}
optional : String -> (a -> b) -> Field b a -> b -> Document a (b -> cons) -> Document a cons
optional name getter (Field dField eField) default (Document d e) =
    Document
        (Decode.optional name dField default d)
        (\value -> ( name, getter value |> eField ) :: e value)



-- Field


{-| -}
type Field a b
    = Field (Decode.Field a) (a -> Encode.Field b)


{-| -}
bool : Field Bool InternalTypes.Bool
bool =
    Field Decode.bool Encode.bool


{-| -}
bytes : Field String InternalTypes.Bytes
bytes =
    Field Decode.bytes Encode.bytes


{-| -}
int : Field Int InternalTypes.Int
int =
    Field Decode.int Encode.int


{-| -}
string : Field String InternalTypes.String
string =
    Field Decode.string Encode.string


{-| -}
list : Field a (InternalTypes.Listable b) -> Field (List a) InternalTypes.List
list (Field d e) =
    Field (Decode.list d) (Encode.list e)


{-| -}
dict : Field a b -> Field (Dict String a) InternalTypes.Dict
dict (Field d e) =
    Field (Decode.dict d) (Encode.dict e)


{-| -}
null : Field () InternalTypes.Null
null =
    Field Decode.null (always Encode.null)


{-| -}
maybe : Field a b -> Field (Maybe a) InternalTypes.Maybe
maybe (Field d e) =
    Field (Decode.maybe d) (Encode.maybe e)


{-| -}
timestamp : Field Posix InternalTypes.Timestamp
timestamp =
    Field Decode.timestamp Encode.timestamp


{-| -}
geopoint : Field Geopoint InternalTypes.Geopoint
geopoint =
    Field Decode.geopoint Encode.geopoint


{-| -}
reference : Field Reference InternalTypes.Reference
reference =
    Field Decode.reference Encode.reference



-- Advanced


{-| -}
map : (a -> b) -> (b -> a) -> Field a tag -> Field b tag
map to from (Field d e) =
    Field (d |> Decode.map to)
        (from >> e)


{-| -}
andThen : (a -> Field b d) -> (b -> a) -> Field a c -> Field b c
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
succeed : a -> Field a InternalTypes.Null
succeed default =
    Field (Decode.succeed default)
        (always Encode.null)


{-| -}
fail : String -> Field a InternalTypes.Null
fail msg =
    Field (Decode.fail msg)
        (always Encode.null)


{-| -}
construct : Decoder a -> (a -> Encoder) -> Codec a
construct d e =
    Codec d e
