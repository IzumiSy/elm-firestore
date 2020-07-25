# elm-firestore
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-firestore.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-firestore)
> A type-safe Firestore integration for Elm. 

The features elm-firestore library supports are as follows:

|Feature|Supported?|
|:------|:---------|
| Simple CRUD operation (get, create, patch, delete) | :white_check_mark: Yes |
| Transactions | :white_check_mark: Yes |
| Realtime update listening | :heavy_exclamation_mark: No|
| Collection group | :heavy_exclamation_mark: No |
| Indexing | :heavy_exclamation_mark: No |

## Example
Almost all [basic types](https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value) in Firestore are supported

```elm
import Firestore
import Firestore.Config as Config
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference
import Firestore.Types.Timestamp as Timestamp
import Firestore.Types.String as FSString
import Firestore.Types.Int as FSInt
import Firestore.Types.List as FSList
import Firestore.Types.Map as FSMap
import Firestore.Types.Bool as FSBool
import Firestore.Types.Null as FSNull


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



-- init


init : ( Model, Cmd Msg )
init =
    let
        config =
            Config.new
                { apiKey = "your-own-api-key"
                , project = "your-firestore-app"
                }
                |> Firestore.withDatabase "your-own-database" -- optional
                |> Firestore.withAuthorization "your-own-auth-token" -- optional

        firestore =
            config
                |> Firestore.init
                |> Firestore.withCollection "documents" -- optional
    in
    ( { firestore = firestore }
    , firestore
        |> Firestore.get decoder
        |> Task.attempt GotDocuments
    )


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



-- update


type Msg
    = GotDocuments


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotDocuments result ->
            case result of
                Ok document ->
                    -- ...

                Err (Firestore.Http_ httpErr) ->
                    -- ...

                Err (Firestore.Response firestoreErr) ->
                    -- ...
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
