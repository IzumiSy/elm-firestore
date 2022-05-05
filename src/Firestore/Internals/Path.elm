module Firestore.Internals.Path exposing
    ( Error(..)
    , Path
    , addCollection
    , addDocument
    , errorString
    , isEmpty
    , new
    , toString
    , validate
    )

import List.Nonempty as NEList


type alias SubCollectionDepth =
    Int


type Path
    = Path (List Element) SubCollectionDepth


{-| Elements that constructs a path

Enum members in this type are intentionally not equal to the one defined in root Firestore module,
but only discrimiates collection and document in order to apply validation rules.

-}
type Element
    = Collection String
    | Document String



-- Constructors


new : Path
new =
    -- second argument (SubCollectionDepth) intentionally starts from minus one
    -- which makes the first call of addCollection as the root collection.
    Path [] -1


addCollection : String -> Path -> Path
addCollection e (Path path depth) =
    Path (path ++ List.singleton (Collection e)) (depth + 1)


addDocument : String -> Path -> Path
addDocument e (Path path depth) =
    Path (path ++ List.singleton (Document e)) depth



-- validation


type Error
    = InvalidCharacterContained
    | TooLongBytes
    | TooDeepSubCollections


{-| Validates a path

This function follows the document provided at: <https://firebase.google.com/docs/firestore/quotas#collections_documents_and_fields>

-}
validate : Path -> Result (NEList.Nonempty Error) Path
validate (Path elements depth) =
    elements
        |> List.map validateElement
        |> List.foldl
            (\next current ->
                case ( next, current ) of
                    ( Ok _, Ok _ ) ->
                        Ok <| Path elements depth

                    ( Ok _, Err err ) ->
                        Err err

                    ( Err err, Ok _ ) ->
                        Err <| NEList.singleton err

                    ( Err err, Err errs ) ->
                        Err <| NEList.cons err errs
            )
            (if depth > 100 then
                Err <| NEList.singleton TooDeepSubCollections

             else
                Ok <| Path elements depth
            )


validateElement : Element -> Result Error Element
validateElement element =
    let
        value =
            unwrapElement element
    in
    if String.length value > 1500 then
        Err TooLongBytes

    else if String.contains "/" value then
        Err InvalidCharacterContained

    else if value == "." || value == ".." then
        Err InvalidCharacterContained

    else
        Ok element


errorString : Error -> String
errorString err =
    case err of
        InvalidCharacterContained ->
            "invalid character contained"

        TooLongBytes ->
            "collection/document ID is too long (it must be under 1500 bytes)"

        TooDeepSubCollections ->
            "subcollections are too deep (it must not be over 100)"



-- Conversion


toString : Path -> String
toString (Path path _) =
    path
        |> List.map unwrapElement
        |> String.join "/"


unwrapElement : Element -> String
unwrapElement e =
    case e of
        Collection value ->
            value

        Document value ->
            value



-- Predicates


isEmpty : Path -> Bool
isEmpty (Path path _) =
    List.isEmpty path
