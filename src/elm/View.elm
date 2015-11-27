module View where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import List
import Json.Decode as Json

import Model exposing (..)
import Routes as R

view : Address Action -> Model -> Html
view addr model =
  div
    []
    [ h1 [] [ text "Elm-SPA-Showcase" ]
    , h2 [] [ text "Cities" ]
    , renderCities addr model.cities
    , link addr R.About [ ] [ text "About" ]
    ]

renderCities : Address Action -> Cities -> Html
renderCities addr cities =
  div
    []
    [ newCity addr cities.new
    , ul [] (List.map (renderCity addr) cities.actual)
    ]

newCity : Address Action -> String -> Html
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

renderCity : Address Action -> City -> Html
renderCity addr city =
  li
    []
    [ text city.name
    , button
        [ onClick addr (DeleteCity city.name)]
        [ text "x" ]
    ]


-- helpers

link : Address Action -> R.Route -> List Attribute -> List Html -> Html
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
