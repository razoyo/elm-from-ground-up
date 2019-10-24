import Browser
import Html exposing (Html)

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


init : Model
init = 
  "Hello World"


-- MODEL
type alias Model =
  String


type alias Msg = 
  String

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  model


-- VIEW
view : Model -> Html.Html Model
view model =
  Html.text "Hello World"
