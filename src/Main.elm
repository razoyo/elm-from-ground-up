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
  { items = [ "Hello World", "Here I Am" ]
  , newItem = ""
  }


init : Model
init = 
  initialModel


-- MODEL
type alias Model =
  { items : List String
  , newItem : String 
  }


type Msg = Capitalize String
  | Reset
  | UpdateNew String
  | AddNew



-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of

    Capitalize item ->
      { model | items = List.map (\x -> capitalizeMatchedItems x item )  model.items }

    Reset ->
      initialModel

    UpdateNew item ->
      { model | newItem = item }

    AddNew ->
      { model | items = model.items ++ [ model.newItem ]
      , newItem = ""
      }


capitalizeMatchedItems : String -> String -> String
capitalizeMatchedItems choice match =
  if choice == match then 
    String.toUpper choice
  else
    choice


-- VIEW
view : Model -> Html Msg
view model =
  div [] [ div [] ( List.map (\x -> 
                    p [ onClick ( Capitalize x ) ] [ text x ] ) 
                    model.items 
                  )
    , p [] [ input [ value model.newItem
                   , onInput UpdateNew ] []
           , button [ onClick AddNew ] [ text "submit" ]
           ] 
    , button [ onClick Reset ] [ text "undo" ]
  ]
