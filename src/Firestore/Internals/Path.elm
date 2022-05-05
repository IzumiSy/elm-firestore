module Firestore.Internals.Path exposing (Path, addCollection, addDocument, new, toString)


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
