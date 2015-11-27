module View where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List
import Json.Decode as Json

import ListComponent
import Model exposing (..)
import Routes as R
import Transit

type alias Addr = Address Action

view : Addr -> Model -> Html
view addr model =
  div
    [ ]
    [ h1 [] [ text "Elm-SPA-Showcase" ]
    , menu addr model.route
    , div
        [ classList
            [ ("page", True)
            , ("exiting", Transit.isExiting model)
            , ("entering", Transit.isEntering model)
            ]
        ]
        [ renderPage addr model ]
    ]

menu : Addr -> R.Route -> Html
menu addr currentRoute =
  let item r label =
        li
          [ classList [ ("current", r == currentRoute) ] ]
          [ link addr r [ ] [ text label ] ]
  in  ul
        [ class "menu" ]
        [ item R.Home "Homepage"
        , item R.About "About"
        ]

renderPage : Addr -> Model -> Html
renderPage addr model =
  case model.page of
    Home ->
      renderCities addr model.cities
    About ->
      renderAbout
    _ ->
      renderNotFound

renderCities : Addr -> Cities -> Html
renderCities addr cities =
  div
    []
    [ h2 [] [ text "Cities" ]
    , newCity addr cities.new
    , ListComponent.view (Signal.forwardTo addr UpdateCities) cities.actual renderCity
    ]

newCity : Addr -> String -> Html
newCity addr new =
  div
    []
    [ input
        [ on "input" targetValue (Signal.message addr << UpdateNewCity)
        , value new
        ]
        []
    , button
        [ onClick addr AddNewCity ]
        [ text "+" ]
    ]

renderCity : Address (ListComponent.Action City) -> Float -> City -> Html
renderCity addr deleteAnimation city =
  li
    [ style [ ("opacity", toString deleteAnimation) ]
    ]
    [ text city.name
    , button
        [ onClick addr (ListComponent.Delete city)]
        [ text "x" ]
    ]

renderAbout : Html
renderAbout =
  p [ ] [ text "About what?" ]

renderNotFound : Html
renderNotFound =
  p [ ] [ text "100% not here." ]

-- helpers

link : Addr -> R.Route -> List Attribute -> List Html -> Html
link addr route attrs content =
  let
    path = R.toUrl route
    linkAttrs =
      [ href path
      , onClickRoute addr (UpdateUrl path)
      ]
  in
    a (linkAttrs ++ attrs) content

onClickRoute : Address a -> a -> Attribute
onClickRoute address msg =
  onWithOptions
    "click"
    { stopPropagation = True, preventDefault = True }
    Json.value (\_ -> message address msg)
