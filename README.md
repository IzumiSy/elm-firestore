# elm-firestore
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-firestore.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-firestore)
> A type-safe Firestore integration for Elm. 

Currently elm-firestore library is supporting:
- Simple CRUD operation (get, create, patch, delete)
- Transactions

However, following features are not supported:
- Realtime update listening
- Collection group
- Indexing

This library leverages v1beta1 REST Resource internally.

## Example
Almost all [basic types](https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value) in Firestore are supported

```elm
import Firestore
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Firestore.Types.Timestamp as Timestamp
import Firestore.Types.String as FSString
import Firestore.Types.Int as FSInt
import Firestore.Types.List as FSList
import Firestore.Types.Map as FSMap
import Firestore.Types.Bool as FSBool
import Firestore.Types.Null as FSNull
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
        |> Pipeline.required "timestamp" Timestamp.decoder
        |> Pipeline.required "geopoint" Geopoint.decoder
        |> Pipeline.required "reference" Reference.decoder
        |> Pipeline.required "integer" FSInt.decoder
        |> Pipeline.required "string" FSString.decoder
        |> Pipeline.required "list" (FSList.decoder FSString.decoder)
        |> Pipeline.required "map" (FSMap.decoder FSString.decoder)
        |> Pipeline.required "boolean" FSBool.decoder
        |> Pipeline.required "nullable" (FSNull.decoder FSString.decoder)


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
