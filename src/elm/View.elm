module View where

import Html exposing (..)
import Signal exposing (..)
import List

import Model exposing (..)

view : Address Action -> Model -> Html
view addr model =
  div
    []
    [ h1 [] [ text "Elm-SPA-Showcase" ]
    , h2 [] [ text "Cities" ]
    , renderItems model.items
    ]

renderItems : List Item -> Html
renderItems items = ul [] (List.map renderItem items)

renderItem : Item -> Html
renderItem item = li [] [ text item.name ]
