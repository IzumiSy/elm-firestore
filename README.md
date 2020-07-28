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

### When will this package support realtime update?
Realtime update listening is one of fundamental features Firestore offers, but this library internally uses Firestore RESTful API which is officially said to be out of support for realtime update. 

I strongly recommend you to use Firestore SDK in JavaScript through Ports instead of this library if you have a strong need to use realtime update on Firestore. This library shall not support it unless Google changes their mind.

## Example
Almost all [basic types](https://firebase.google.com/docs/firestore/reference/rest/v1beta1/Value) in Firestore are supported

```elm
import Firestore
import Firestore.Config as Config
import Firestore.Encode as FSEncode
import Firestore.Decode as FSDecode
import Firestore.Types.Geopoint as Geopoint
import Firestore.Types.Reference as Reference


-- model


type alias Model =
    { firestore : Firestore.Firestore
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
        |> Pipeline.required "timestamp" FSDecode.timestamp
        |> Pipeline.required "geopoint" Geopoint.decode
        |> Pipeline.required "reference" Reference.decode
        |> Pipeline.required "integer" FSDecode.int
        |> Pipeline.required "string" FSDecode.string
        |> Pipeline.required "list" (FSDecode.list FSDecode.string)
        |> Pipeline.required "map" (FSDecode.dict FSDecode.string)
        |> Pipeline.required "boolean" FSDecode.bool
        |> Pipeline.required "nullable" (FSDecode.maybe FSDecode.string)



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
