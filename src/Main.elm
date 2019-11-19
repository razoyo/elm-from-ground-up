import Browser

import Element exposing (Element
  , el
  , text
  , row
  , column
  , alignRight
  , alignTop
  , fill
  , layout
  , none
  , width
  , rgb255
  , spacing
  , centerX
  , centerY
  , padding)

import Element.Background as Background
import Element.Border as Border
import Element.Events exposing ( onClick )
import Element.Font as Font
import Element.Input as Input

import Html

import Dict

import Styles exposing ( heading1
  , actionX
  , red
  , sortButton
  , standardButton )



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
      { model | items = Dict.map (\k v -> Item v.item v.displayStatus False v.length ) model.items }

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
view : Model -> Html.Html Msg
view model =
  layout [ width fill, padding 10 ]
    <|
      column [ width fill, alignTop, padding 10, spacing 10 ] [ el heading1 ( text ( headList model.items ) ) 
         , row [width fill, spacing 10] [ el [ ] ( text "sort operation : " )
           , Input.button sortButton { onPress = Just ( Sort Order ), label = text "order" }
           , Input.button sortButton { onPress = Just ( Sort Asc ), label = text "a - z" }
           , Input.button sortButton { onPress = Just ( Sort Desc ), label = text "z - a" }
           , Input.button sortButton { onPress = Just ( Sort AscLength ), label = text "short - long" }
           , Input.button sortButton { onPress = Just ( Sort DescLength ), label = text "long - short" }
           ]
         , column [ spacing 15, padding 20 ] ( sortedList model.items model.sortBy )
         , row [ spacing 10 ] [ Input.text [] { text = model.newItem
                        , placeholder = Nothing
                        , onChange = UpdateNew
                        , label = Input.labelLeft [ centerY ] (text "Add item : ") }
                  , Input.button standardButton { onPress = Just AddNew, label = text "submit" }
                  ]
         , row [] [ Input.button standardButton { onPress = Just Reset, label = text "reset" } ]
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


sortedList : Dict.Dict Int Item -> SortOperation -> List ( Element Msg )
sortedList items sortBy =

  let
    itemList =
      items
      |> Dict.map itemElement
      |> Dict.values

    itemElement k v =
      let
        deleteButton =
          el ( ( onClick ( Delete k ) ) :: actionX )  ( text "x" ) 

        displayItem =
          if v.editing == False then
            row [ spacing 20 ] [
               el [ onClick ( ToggleCase k ) ] ( text ( applyDisplayMode v ) )
               , Input.button standardButton { onPress = Just ( EditItem k ), label =  text "edit"  }
               , deleteButton
            ]
          else
            row [ spacing 20 ] [ Input.text [] { onChange = UpdateItem k v 
                                  , text = v.item
                                  , placeholder = Nothing
                                  , label = Input.labelLeft []  none }
              , Input.button standardButton { onPress = Just StopEdit, label =  text "save" }
              , deleteButton
            ]

      in

      { element = displayItem
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
