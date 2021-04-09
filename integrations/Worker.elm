module Worker exposing (main)


type alias Model =
    {}


init : () -> ( Model, Cmd msg )
init _ =
    ( {}, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


main : Program () Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
