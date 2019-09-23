module Firestore.Path exposing
    ( Path
    , append
    , empty
    , toString
    )


type Path
    = Path (List String)


empty : Path
empty =
    Path []


append : String -> Path -> Path
append value (Path paths) =
    paths
        |> List.append (List.singleton value)
        |> Path


toString : Path -> String
toString (Path paths) =
    String.join "/" paths
