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
  { items = Dict.fromList [ ( 1, Item "Hello World" Original False 11 )
                          , ( 2, Item "Here I Am" Original False 9 ) 
                          ]
  , newItem = ""
  , sortBy = Order
  }


emptyItem =
  Item "N/A" Original False 0


newKey : Dict.Dict Int Item -> Int
newKey items =
  Dict.keys items 
  |> List.maximum 
  |> Maybe.withDefault 0 
  |> (\x -> x + 1)


init : Model
init =
  initialModel



-- MODEL
type alias Model =
  { items : Dict.Dict Int Item
  , newItem : String
  , sortBy : SortOperation
  }


type Msg = ToggleCase Int
  | Reset
  | UpdateNew String
  | AddNew
  | Delete Int
  | Sort SortOperation
  | EditItem Int
  | UpdateItem Int Item String
  | StopEdit


type SortOperation = Order | Asc | Desc | AscLength | DescLength


type DisplayStatus = Original | Capitalized


type alias Item = 
  { item : String
  , displayStatus : DisplayStatus
  , editing : Bool
  , length : Int
  }



-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of

    ToggleCase key ->
      let
        newStatus currentStatus = 
          case currentStatus of
            Capitalized -> Original
            Original -> Capitalized

        updatedItem = Dict.get key model.items
                      |> Maybe.withDefault emptyItem
                      |> (\x -> Item x.item (newStatus x.displayStatus) x.editing x.length)
      in

      { model | items = Dict.insert key updatedItem model.items }

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

    EditItem key ->
      let
        resetItems items = Dict.map (\k v -> { v | editing = False } ) items

        updatedItem = Dict.get key model.items
                      |> Maybe.withDefault emptyItem
                      |> (\x -> Item x.item x.displayStatus (not x.editing) x.length)
      in

      { model | items = Dict.insert key updatedItem (resetItems model.items) }

    UpdateItem key item newItem ->
      { model | items = Dict.insert key { item | item = newItem } model.items }

    StopEdit ->
      -- { model | items = Dict.map (\k v -> Item v.item v.displayStatus False v.length ) model.items }
      { model | items = Dict.map (\k v -> { v | editing = False } ) model.items }

addNewItem : Model -> Model
addNewItem model =
  let
    newItem = model.newItem
    items = model.items
  in
  { model | items = Dict.insert ( newKey items ) ( Item newItem Original False ( String.length newItem ) ) items
  , newItem = ""
  }
  

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
      let
        deleteButton =
          span [ style "margin-left" "10px"
               , style "color" "red"
               , style "font-family" "sans-serif"
               , onClick ( Delete k ) 
             ] [ text "x" ] 
      in
      { element = 
          div [] [ if v.editing == False then
            div [] [
               span [ onClick ( ToggleCase k ) ] [ text ( applyDisplayMode v ) ]
               , button [ onClick ( EditItem k ) ] [ text "edit" ]
               , deleteButton
               ]
            else
            form [onSubmit StopEdit] [
              input [ value v.item, onInput ( UpdateItem k v ) ] []
              , button [] [ text "save" ]
              , deleteButton
            ]
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


applyDisplayMode : Item -> String
applyDisplayMode item =
  case item.displayStatus of
    Capitalized ->
      String.toUpper item.item

    _ ->
      item.item
