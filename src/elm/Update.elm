module Update where

import Effects exposing (Effects)

import Model exposing (..)


init : (Model, Effects Action)
init = ({ user = { name = "Tom" }}, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  (model, Effects.none)
