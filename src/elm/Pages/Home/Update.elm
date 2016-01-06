module Pages.Home.Update where

import Effects exposing (Effects, none)

import Inputs exposing (homeAddr)
import Pages.Home.Model exposing (..)


init : (Model, Effects Action)
init =
  (initial, none)

initial : Model
initial =
  ()

update : Action -> Model -> (Model, Effects Action)
update action model =
  (model, none)
