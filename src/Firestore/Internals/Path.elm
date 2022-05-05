module Firestore.Internals.Path exposing
    ( Error(..)
    , Path
    , addCollection
    , addDocument
    , errorString
    , new
    , toString
    , validate
    )

import List.Nonempty as NEList


type Path
    = Path (List Element)


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
    Path []


addCollection : String -> Path -> Path
addCollection e (Path path) =
    Path <| path ++ List.singleton (Collection e)


addDocument : String -> Path -> Path
addDocument e (Path path) =
    Path <| path ++ List.singleton (Document e)



-- validation


type Error
    = InvalidCharacterContained


validate : Path -> Result (NEList.Nonempty Error) Path
validate (Path elements) =
    elements
        |> List.map validateElement
        |> List.foldl
            (\next current ->
                case ( next, current ) of
                    ( Ok _, Ok _ ) ->
                        Ok <| Path elements

                    ( Ok _, Err err ) ->
                        Err err

                    ( Err err, Ok _ ) ->
                        Err <| NEList.singleton err

                    ( Err err, Err errs ) ->
                        Err <| NEList.cons err errs
            )
            (Ok <| Path elements)


validateElement : Element -> Result Error Element
validateElement e =
    Ok e


errorString : Error -> String
errorString e =
    case e of
        InvalidCharacterContained ->
            "invalid character contained"



-- Conversion


toString : Path -> String
toString (Path path) =
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
