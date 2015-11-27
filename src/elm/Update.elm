module Update where

import Effects exposing (Effects)

import Model exposing (..)

init : (Model, Effects Action)
init = (initialModel, Effects.none)

initialModel : Model
initialModel =
  { user = { name = "Tom" }
  , items =
      [ { name = "Paris" }
      , { name = "Nantes" }
      , { name = "Tokyo" }
      , { name = "Bouguenais" }
      ]
  }

update : Action -> Model -> (Model, Effects Action)
update action model = (model, Effects.none)
