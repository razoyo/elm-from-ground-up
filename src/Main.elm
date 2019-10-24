import Browser
import Html exposing ( Html, text, p, button, div )
import Html.Events exposing ( onClick )

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


init : Model
init = 
  ( "Hello World", "Here I Am" )


-- MODEL
type alias Model =
  ( String, String )


type Msg = Capitalize Int
  | Decapitalize

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    Capitalize position ->
      let
          ( first, second ) = model
      in

      case position of
        1 -> 
          ( String.toUpper first, second )

        _ ->
          ( first, String.toUpper second )


    Decapitalize ->
      let
          ( first, second ) = model

          newModel = ( String.toLower first, String.toLower second )
      in
         newModel


-- VIEW
view : Model -> Html Msg
view model =
  let 
      ( first, second ) = model
  in
  div [] [
    p [ onClick ( Capitalize 1 ) ] [ text first ]
    , p [ onClick ( Capitalize 2 ) ] [ text second ]
    , button [ onClick Decapitalize ] [ text "undo" ]
  ]
