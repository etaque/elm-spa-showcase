module Pages.Cities.View where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Pages.Cities.Model exposing (..)
import Inputs exposing (citiesAddr)

import ListComponent


view : Model -> Html
view model =
  div
    []
    [ h2 [] [ text "Cities" ]
    , newCity model.new
    , ListComponent.view (Signal.forwardTo citiesAddr UpdateAll) model.actual renderCity
    ]

newCity : String -> Html
newCity new =
  div
    []
    [ input
        [ on "input" targetValue (Signal.message citiesAddr << UpdateNew)
        , value new
        ]
        []
    , button
        [ onClick citiesAddr AddNew ]
        [ text "+" ]
    ]

renderCity : Signal.Address (ListComponent.Action City) -> Float -> City -> Html
renderCity addr deleteAnimation city =
  li
    [ style [ ("opacity", toString deleteAnimation) ]
    ]
    [ text city.name
    , button
        [ onClick addr (ListComponent.Delete city)]
        [ text "x" ]
    ]
