module View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import List

import Model exposing (..)

view : Address Action -> Model -> Html
view addr model =
  div
    []
    [ h1 [] [ text "Elm-SPA-Showcase" ]
    , h2 [] [ text "Cities" ]
    , renderCities addr model.cities
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
