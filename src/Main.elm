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
  , padding
  , mouseOver
  , pointer)


import Element.Background as Background
import Element.Border as Border
import Element.Events exposing ( onClick )
import Element.Font as Font
import Element.Input as Input

import Html
import Html.Events

import Http

import Json.Decode as Decode exposing (Decoder, field, int, string, list, map3)

import Dict

import Styles exposing ( heading1
  , actionX
  , red
  , sortButton
  , standardButton )

-- import CommOps exposing ( Item, DisplayStatus, repoDecoder )



main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


initialModel =
  { items = Dict.empty 
  , newItem = ""
  , sortBy = Order
  }


init : () -> ( Model, Cmd Msg )
init _ =
  ( initialModel
  , Http.get 
    { url = "https://api.github.com/users/razoyo/repos"
    , expect =  Http.expectJson LoadRepos reposDecoder } 
  )

getRepos : Cmd Msg
getRepos =
  Http.get 
    { url = "https://api.github.com/users/razoyo/repos"
    , expect =  Http.expectJson LoadRepos reposDecoder } 

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- MODEL
type alias Model =
  { items : Dict.Dict String Item
  , newItem : String
  , sortBy : SortOperation
  }


type Msg = ToggleCase String
  | Reset
  | UpdateNew String
  | AddNew
  | Delete String
  | Sort SortOperation
  | EditItem String
  | UpdateItem String Item String
  | StopEdit
  | LoadRepos ( Result Http.Error ( List PreItem ) )


type SortOperation = Order | Asc | Desc



-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of

    LoadRepos result ->
      let
        repos = 
           case result of
             Err _ ->
               Dict.empty

             Ok repoList ->
               let
                 item preItem =
                   ( String.fromInt preItem.id
                   , Item preItem.item Original False preItem.description )
 
                 items = List.map (\x -> ( item x ) ) repoList
                                
               in
               Dict.fromList items
      in
      ( { model | items = repos }, Cmd.none )

    ToggleCase key ->
      let
        newStatus currentStatus = 
          case currentStatus of
            Capitalized -> Original
            Original -> Capitalized

        updatedItem = Dict.get key model.items
                      |> Maybe.withDefault emptyItem
                      |> ( \x -> Item x.item (newStatus x.displayStatus) x.editing x.description )
      in

      ( { model | items = Dict.insert key updatedItem model.items }, Cmd.none )

    Reset ->
      ( initialModel, getRepos )

    UpdateNew item ->
      ( { model | newItem = item }, Cmd.none )

    AddNew ->
      ( addNewItem model, Cmd.none )

    Delete item ->
      ( { model | items = ( Dict.remove item model.items ) }, Cmd.none )

    Sort operation ->
      ( { model | sortBy = operation }, Cmd.none )

    EditItem key ->
      let
        resetItems items = Dict.map (\k v -> { v | editing = False } ) items

        updatedItem = Dict.get key model.items
                      |> Maybe.withDefault emptyItem
                      |> (\x -> Item x.item x.displayStatus (not x.editing) x.description )
      in

      ( { model | items = Dict.insert key updatedItem (resetItems model.items) }, Cmd.none )

    UpdateItem key item newItem ->
      ( { model | items = Dict.insert key { item | item = newItem } model.items }, Cmd.none )

    StopEdit ->
      ( { model | items = Dict.map (\k v -> Item v.item v.displayStatus False v.description ) model.items }, Cmd.none )


addNewItem : Model -> Model
addNewItem model =

  let
    newItem = model.newItem
    items = model.items
    newKey = ( String.slice 0 3 newItem ) ++ ( String.fromInt ( String.length newItem ) )
  in

  { model | items = Dict.insert newKey ( Item newItem Original False "" ) items
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
           ]
         , column [ spacing 15, padding 20 ] ( sortedList model.items model.sortBy )
         , row [ spacing 10 ] [ Input.text [ onEnter AddNew ] { text = model.newItem
                        , placeholder = Nothing
                        , onChange = UpdateNew
                        , label = Input.labelLeft [ centerY ] (text "Add item : ") }
                  , Input.button standardButton { onPress = Just AddNew, label = text "submit" }
                  ]
         , row [] [ Input.button standardButton { onPress = Just Reset, label = text "reset" } ]
      ]


headList : Dict.Dict String Item -> String
headList items =
  let
    item = items
           |> Dict.toList
           |> List.head 
  in

  case item of 
    Just data ->
      let
        ( k , v ) = data
        firstItem = v.item
      in
      "List starting with \"" ++ firstItem ++ "\""

    Nothing ->
      "Empty List"


sortedList : Dict.Dict String Item -> SortOperation -> List ( Element Msg )
sortedList items sortBy =

  let
    itemList =
      items
      |> Dict.map itemElement
      |> Dict.values

    itemElement k v =
      let
        deleteButton =
          el ( [ onClick ( Delete k ), pointer ] ++ actionX ) ( text "x" ) 

        displayItem =
          if v.editing == False then
            row [ spacing 20 ] [ el [] ( text k )
               , el [ onClick ( ToggleCase k ) ] ( text ( applyDisplayMode v ) )
               , Input.button standardButton { onPress = Just ( EditItem k ), label =  text "edit"  }
               , deleteButton
            ]
          else
            row [ spacing 20 ] [ Input.text [ onEnter StopEdit ] { onChange = UpdateItem k v 
                                  , text = v.item
                                  , placeholder = Nothing
                                  , label = Input.labelLeft []  none }
              , Input.button standardButton { onPress = Just StopEdit, label =  text "save" }
              , deleteButton
            ]

      in

      { element = displayItem
      , item = v.item }
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


applyDisplayMode : Item -> String
applyDisplayMode item =
  let
    displayStatus = item.displayStatus
  in

  case displayStatus of
    Capitalized ->
      String.toUpper item.item

    _ ->
      item.item


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )

--- Module check


type DisplayStatus = Original | Capitalized


type alias Item = 
  { item : String -- we'll use the name field from Github's JSON response
  , displayStatus : DisplayStatus
  , editing : Bool
  , description : String
  }


emptyItem =
  Item "" Original False "" 


type alias PreItem =
  { id : Int
  , item : String -- we'll use the name field from Github's JSON response
  , description : String
  }


reposDecoder : Decoder (List PreItem)
reposDecoder =
  ( list repoDecoder )

repoDecoder : Decoder PreItem
repoDecoder =
  map3 PreItem
    (field "id" int)
    (field "name" string)
    (field "full_name" string)
