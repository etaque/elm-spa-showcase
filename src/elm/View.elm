module View where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import Json.Decode as Json

import TransitStyle
import TransitRouter exposing (getTransition)

import Model exposing (..)
import Action exposing (..)
import Routes exposing (..)

import Pages.Home.View as Home
import Pages.Cities.View as Cities

import Action exposing (PageAction)


view : Address Action -> Model -> Html
view _ model =
  div
    [ ]
    [ h1 [] [ text "Elm Vespa" ]
    , menu (TransitRouter.getRoute model)
    , div
        [ class "page"
        , style (TransitStyle.fadeSlideLeft 100 (getTransition model))
        ]
        [ renderPage model ]
    ]


menu : Route -> Html
menu currentRoute =
  let
    item r label =
      li
        [ classList [ ("current", r == currentRoute) ] ]
        [ a (clickTo (Routes.toPath r)) [ text label ] ]
  in
    ul
      [ class "menu" ]
      [ item Home "Homepage"
      , item Cities "Cities"
      , item About "About"
      ]


renderPage : Model -> Html
renderPage model =
  case (TransitRouter.getRoute model) of

    Home ->
      Home.view model.pages.home

    Cities ->
      Cities.view model.pages.cities

    About ->
      renderAbout

    NotFound ->
      renderNotFound

    EmptyRoute ->
      text ""


renderAbout : Html
renderAbout =
  p [ ] [ text "About what?" ]


renderNotFound : Html
renderNotFound =
  p [ ] [ text "100% not here." ]


-- helpers

clickTo : String -> List Attribute
clickTo path =
  [ href path
  , onWithOptions
      "click"
      { stopPropagation = True, preventDefault = True }
      Json.value
      (\_ -> message TransitRouter.pushPathAddress path)
  ]
