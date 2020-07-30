# elm-firestore
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-firestore.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-firestore)
> A type-safe Firestore integration for Elm. 

The features elm-firestore library supports are as follows:

|Feature|Supported?|
|:------|:---------|
| Simple CRUD operation (get, list, create, patch, delete) | :white_check_mark: Yes |
| Transactions | :white_check_mark: Yes |
| Realtime update listening | :heavy_exclamation_mark: No|
| Collection group | :heavy_exclamation_mark: No |
| Indexing | :heavy_exclamation_mark: No |

### When will this package support realtime update?
Realtime update listening is one of fundamental features Firestore offers, but this library internally uses Firestore RESTful API which is officially said to be out of support for realtime update. 

I strongly recommend you to use Firestore SDK in JavaScript through Ports instead of this library if you have a strong need to use realtime update on Firestore. This library shall not support it unless Google changes their mind.

## Example
Almost all [basic types](https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value) in Firestore are supported

```elm
import Firestore
import Firestore.Config as Config
import Firestore.Decode as FSDecode
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference


-- model


type alias Model =
    { firestore : Firestore.Firestore
    , document : Firestore.Document Document
    }


type alias Document =
    { timestamp : Time.Posix
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
                |> Config.withDatabase "your-own-database" -- optional
                |> Config.withAuthorization "your-own-auth-token" -- optional

        firestore =
            config
                |> Firestore.init
                |> Firestore.withCollection "documents" -- optional
    in
    ( { firestore = firestore }
    , firestore
        |> Firestore.get decoder
        |> Task.attempt GotDocument
    )


decoder : FSDecode.Decoder Document
decoder =
    FSDecode.document Document
        |> FSDecode.required "timestamp" FSDecode.timestamp
        |> FSDecode.required "geopoint" FSDecode.geopoint
        |> FSDecode.required "reference" FSDecode.reference
        |> FSDecode.required "integer" FSDecode.int
        |> FSDecode.required "string" FSDecode.string
        |> FSDecode.required "list" (FSDecode.list FSDecode.string)
        |> FSDecode.required "map" (FSDecode.dict FSDecode.string)
        |> FSDecode.required "boolean" FSDecode.bool
        |> FSDecode.required "nullable" (FSDecode.maybe FSDecode.string)



-- update


type Msg
    = GotDocument (Result Firestore.Error (Firestore.Document Document))


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotDocument result ->
            case result of
                Ok document ->
                    ( { model | document = document }, Cmd.none )

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
