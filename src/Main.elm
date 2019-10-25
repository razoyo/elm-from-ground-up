import Browser
import Html exposing ( Html, text, p, button, div, input )
import Html.Events exposing ( onClick, onInput )
import Html.Attributes exposing ( value )

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


initialModel =
  Model "Hello World" "Here I Am" ""


init : Model
init = 
  initialModel


-- MODEL
type alias Model =
  { first: String
  , second: String 
  , third : String 
  }


type Msg = Capitalize Position
  | Reset
  | AddNew String


type Position = First
  | Second
  | Third

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of

    Capitalize position ->
      case position of
        First ->
          { model | first = String.toUpper model.first }

        Second ->
          { model | second = String.toUpper model.second }

        Third ->
          { model | third = String.toUpper model.third }


    Reset ->
      initialModel

    AddNew text ->
      { model | third = text }
    

    
-- VIEW
view : Model -> Html Msg
view model =
  div [] [
    p [ onClick ( Capitalize First ) ] [ text model.first ]
    , p [ onClick ( Capitalize Second ) ] [ text model.second ]
    , p [ onClick ( Capitalize Third ) ] [ text model.third ]
    , p [] [ input [ value model.third, onInput AddNew ] [ ] ]
    , button [ onClick Reset ] [ text "undo" ]
  ]
