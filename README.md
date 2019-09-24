# elm-firestore
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-firestore.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-firestore)

A type-safe Firestore integration for Elm

## Example

### Types
```elm
type alias Document =
    { timestamp : Timestamp.Timestamp
    , geopoint : Geopoint.Geopoint
    , reference : Reference.Reference
    , integer : Int
    , string : String
    , list : List String
    , map : Dict.Dict String String
    , boolean : Bool
    , nullable : Maybe String
    }


decoder : Decode.Decoder Document
decoder =
    Decode.succeed Document
        |> Pipeline.required "timestamp" Types.timestamp
        |> Pipeline.required "geopoint" Types.geopoint
        |> Pipeline.required "referenec" Types.reference
        |> Pipeline.required "integer" Types.int
        |> Pipeline.required "string" Types.string
        |> Pipeline.required "list" (Types.list Types.string)
        |> Pipeline.required "map" (Types.map Types.string)
        |> Pipeline.required "boolean" Types.bool
        |> Pipeline.required "nullable" (Types.null Types.string)
```

## Contribution
PRs accepted
