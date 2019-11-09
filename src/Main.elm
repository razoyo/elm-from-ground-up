import Browser
import Html exposing ( Html, text, p, button, div, input, span, form, h1 )
import Html.Events exposing ( onClick, onInput, onSubmit )
import Html.Attributes exposing ( value, style )
import Dict


main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


initialModel =
  { items = Dict.fromList [ ( 1, { item = "Hello World", length = 11 } )
    , ( 2, { item = "Here I Am", length = 9} ) 
    ]
  , newItem = ""
  , sortBy = Order
  }


init : Model
init = 
  initialModel



-- MODEL
type alias Model =
  { items : Dict.Dict Int Item
  , newItem : String
  , sortBy : SortOperation
  }


type Msg = Capitalize Int
  | Reset
  | UpdateNew String
  | AddNew
  | Delete Int
  | Sort SortOperation


type SortOperation = Order | Asc | Desc | AscLength | DescLength


type alias Item = 
  { item : String
  , length : Int
  }



-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of

    Capitalize key ->
      { model | items = ( findAndCapitalize key model.items ) }

    Reset ->
      initialModel

    UpdateNew item ->
      { model | newItem = item }

    AddNew ->
      addNewItem model

    Delete item ->
      { model | items = ( Dict.remove item model.items ) }

    Sort operation ->
      { model | sortBy = operation }


addNewItem : Model -> Model
addNewItem model =
  { model | items = Dict.insert ( ( Dict.keys model.items |> List.maximum |> Maybe.withDefault 0 ) + 1 ) ( Item model.newItem ( String.length model.newItem ) ) model.items
  , newItem = ""
  }


findAndCapitalize : Int -> Dict.Dict Int Item -> Dict.Dict Int Item
findAndCapitalize key items =
  let
    item = Dict.get key items
  in

  case item of
    Just value ->
      Dict.insert key { item = value.item, length = String.length value.item } items

    Nothing -> -- if you can't find it - which shouldn't happen - just return the old list
      items


-- VIEW
view : Model -> Html Msg
view model =
  div [] [ h1 [] [ text ( headList model.items ) ] 
         , div [] [ span [] [ text "sort operation : " ]
           , button [ onClick ( Sort Order ) ] [ text "order" ] 
           , button [ onClick ( Sort Asc ) ] [ text "a - z" ] 
           , button [ onClick ( Sort Desc ) ] [ text "z - a" ] 
           , button [ onClick ( Sort AscLength ) ] [ text "short - long" ] 
           , button [ onClick ( Sort DescLength ) ] [ text "long - short" ] 
           ]
         , div [] ( sortedList model.items model.sortBy )
           , form [ onSubmit AddNew ] [ input [ value model.newItem, onInput UpdateNew ] []
                  , button [ style "margin-left" "10px" ] [ text "submit" ]
                  ] 
    , button [ onClick Reset ] [ text "reset" ]
  ]


headList : Dict.Dict Int Item -> String
headList items =
  let
    item = items
           |> Dict.toList
           |> List.head -- this will produce a Maybe condition since a list may be empty
  in

  case item of 
    Just data -> -- if the list is not empty
      let
        ( k , v ) = data
        firstItem = v.item
      in
      "List starting with \"" ++ firstItem ++ "\""

    Nothing -> -- if the list is empty
      "Empty List"


sortedList : Dict.Dict Int Item -> SortOperation -> List ( Html Msg )
sortedList items sortBy =

  let
    itemList =
      items
      |> Dict.map itemElement
      |> Dict.values

    itemElement k v =
      { element = p [] [ span [ onClick ( Capitalize k ) ] [ text v.item ]
             , span [ style "margin-left" "10px"
               , style "color" "red"
               , style "font-family" "sans-serif"
               , onClick ( Delete k ) 
             ] [ text "x" ] 
           ]
      , item = v.item
      , length = v.length }
  in

  case sortBy of
    Order ->
      itemList
      |> List.map .element

    Asc ->
      itemList
      |> List.sortBy .item
      |> List.map .element

    Desc ->
      itemList
      |> List.sortBy .item
      |> List.map .element
      |> List.reverse

    AscLength ->
      itemList
      |> List.sortBy .length
      |> List.map .element

    DescLength ->
      itemList
      |> List.sortBy .length
      |> List.map .element
      |> List.reverse

