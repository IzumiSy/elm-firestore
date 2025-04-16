# elm-firestore

[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/IzumiSy/elm-firestore/test.yaml?branch=master)](https://github.com/IzumiSy/elm-firestore)
[![Elm package](https://img.shields.io/elm-package/v/IzumiSy/elm-firestore)](https://package.elm-lang.org/packages/IzumiSy/elm-firestore/)

A type-safe Firestore integration module for Elm. No JavaScript/TypeScript needed for ports.

The features elm-firestore library supports are as follows:

| Feature                                                  | Supported?                  |
| :------------------------------------------------------- | :-------------------------- |
| Simple CRUD operation (get, list, create, patch, delete) | :white_check_mark: Yes      |
| Transactions                                             | :white_check_mark: Yes      |
| Collection group                                         | :white_check_mark: Yes      |
| Query                                                    | Partially supported         |
| Realtime update listening                                | :heavy_exclamation_mark: No |

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
import Result.Extra as ExResult


-- model


type alias Model =
    { firestore : Firestore.Firestore
    , document : Maybe (Firestore.Document Document)
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
        firestore =
            Config.new
                { apiKey = "your-own-api-key"
                , project = "your-firestore-app"
                }
                |> Config.withDatabase "your-own-database" -- optional
                |> Config.withAuthorization "your-own-auth-token" -- optional
                |> Firestore.init
    in
    ( { firestore = firestore, document = Nothing }
    , firestore
        |> Firestore.root
        |> Firestore.collection "users"
        |> Firestore.document "user1"
        |> Firestore.build
        |> ExResult.toTask
        |> Task.andThen (Firestore.get decoder)
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


encoder : Document -> FSEncode.Encoder
encoder doc =
    FSEncode.new
        |> FSEncode.field "timestamp" (FSEncode.timestamp doc.timestamp)
        |> FSEncode.field "geopoint" (FSEncode.geopoint doc.geopoint)
        |> FSEncode.field "reference" (FSEncode.reference doc.reference)
        |> FSEncode.field "integer" (FSEncode.int doc.integer)
        |> FSEncode.field "string" (FSEncode.string doc.string)
        |> FSEncode.field "list" (FSEncode.list FSEncode.string doc.list)
        |> FSEncode.field "map" (FSEncode.dict FSEncode.string doc.map)
        |> FSEncode.field "boolean" (FSEncode.bool doc.boolean)
        |> FSEncode.build



-- update


type Msg
    = GotDocument (Result Firestore.Error (Firestore.Document Document))
    | SaveDocument Document


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        SaveDocument doc ->
            ( model
            , model.firestore
                |> Firestore.root
                |> Firestore.collection "users"
                |> Firestore.document "user1"
                |> Firestore.build
                |> ExResult.toTask
                |> ExResult.toTask
                |> Task.andThen (Firestore.insert decoder (encoder doc))
                |> Task.attempt GotDocument
            )

        GotDocument result ->
            case result of
                Ok document ->
                    ( { model | document = Just document }, Cmd.none )

                Err (Firestore.Http_ httpErr) ->
                    -- ...

                Err (Firestore.Response firestoreErr) ->
                    -- ...
```

## Development

### Setup

Install pnpm to setup elm-firestore development

```shell
$ pnpm install
```

### Build

```shell
$ pnpm build
```

### Unit testing

```shell
$ pnpm test
```

### Integration testing

This requires you to install Open JDK to run Firestore Emulator.

```shell
$ pnpm test:integration:setup
$ pnpm test:integration
```

## License

MIT

## Contribution

PRs accepted
