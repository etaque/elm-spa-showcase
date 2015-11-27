module View where

import Html exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (..)
import List

import Model exposing (..)

view : Address Action -> Model -> Html
view addr model =
  div
    []
    [ h1 [] [ text "Elm-SPA-Showcase" ]
    , h2 [] [ text "Cities" ]
    , renderItems addr model.items
    ]

renderItems : Address Action -> List Item -> Html
renderItems addr items = ul [] (List.map (renderItem addr) items)

renderItem : Address Action -> Item -> Html
renderItem addr item =
  li
    []
    [ text item.name
    , button
        [ onClick addr (DeleteItem item.name)]
        [ text "x" ]
    ]
