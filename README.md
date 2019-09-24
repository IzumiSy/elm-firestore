# elm-firestore
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-firestore.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-firestore)
> A type-safe Firestore integration for Elm. 

Currently elm-firestore library is supporting:
- Simple CRUD operation (get, create, patch, delete)
- Transactions

## Example
Almost all [basic types](https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value) in Firestore are supported

```elm
import Firestore
import Firestore.Types as Types
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Firestore.Types.Timestamp as Timestamp
import Firestore.Config.APIKey as APIKey
import Firestore.Config.ProjectId as ProjectId
import Firestore.Config.DatabaseId as DatabaseId


-- model


type alias Model =
    { firestore : Firestore.Firestore
    }


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
        |> Pipeline.required "reference" Types.reference
        |> Pipeline.required "integer" Types.int
        |> Pipeline.required "string" Types.string
        |> Pipeline.required "list" (Types.list Types.string)
        |> Pipeline.required "map" (Types.map Types.string)
        |> Pipeline.required "boolean" Types.bool
        |> Pipeline.required "nullable" (Types.null Types.string)


-- init


init : ( Model, Cmd Msg )
init =
    let
        firestore =
            Firestore.configure 
                { apiKey = APIKey.new "your-own-api-key"
                , projectId = ProjectId.new "your-firestore-app"
                , databaseId = DatabaseId.default
                }
    in
    ( { firestore = firestore }
    , firestore 
        |> Firestore.collection "documents"
        |> Firestore.get decoder
        |> Task.attempt GotDocuments
    )
```

## Development

### Setup
```shell
$ npm install
```

### Build
```shell
$ npm run build
```

### Testing
```shell
$ npm test
```

## License
MIT

## Contribution
PRs accepted
