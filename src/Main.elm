import Browser
import Html exposing ( Html, text, p )
import Html.Events exposing ( onClick )

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


type Msg = 
  Capitalize

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    Capitalize ->
      String.toUpper model


-- VIEW
view : Model -> Html Msg
view model =
  p [ onClick Capitalize ] [ text model ]
