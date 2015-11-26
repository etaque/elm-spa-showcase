module View where

import Html exposing (..)
import Signal exposing (..)

import Model exposing (..)


view: Address Action -> Model -> Html
view addr model =
  div [] [ text "hello" ]
