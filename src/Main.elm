import Browser
import Html exposing ( Html, text, p, button, div, input, span, form, a )
import Html.Events exposing ( onClick, onInput, onSubmit )
import Html.Attributes exposing ( value, style )

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


initialModel =
  { items = [ "Hello World", "Here I Am" ]
  , sortOrder = Asc
  , newItem = ""
  }


init : Model
init = 
  initialModel


-- MODEL
type alias Model =
  { items : List String
  , sortOrder : SortOrder
  , newItem : String
  }


type Msg = Capitalize String
  | Reset
  | UpdateNew String
  | AddNew
  | Delete String
  | Sort


type SortOrder = Asc | Desc



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
      addNewItem model

    Delete item ->
      { model | items = List.filter (\x-> item /= x ) model.items }

    Sort ->
      let
        newOrder = 
          case model.sortOrder of
            Asc -> Desc
            Desc -> Asc

        itemListSorted = List.sort model.items

        newList = 
          case newOrder of
            Asc ->
              itemListSorted

            Desc ->
              List.reverse itemListSorted
      in

        { model | items = newList
        , sortOrder = newOrder
        }

addNewItem : Model -> Model
addNewItem model =
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
  div [] [ div [] [ button [ onClick Sort ] [ text "sort" ] ]
    , div [] ( List.map 
             (\x -> p [] [ span [ onClick ( Capitalize x ) ] [ text x ]
                         , span [ style "margin-left" "10px"
                                , style "color" "red"
                                , style "font-family" "sans-serif"
                                , onClick ( Delete x ) ] [ text "x" ] 
                         ]
             ) model.items
           )
           , form [ onSubmit AddNew ] [ input [ value model.newItem, onInput UpdateNew ] []
                  , button [ style "margin-left" "10px" ] [ text "submit" ]
                  ] 
    , button [ onClick Reset ] [ text "reset" ]
  ]
