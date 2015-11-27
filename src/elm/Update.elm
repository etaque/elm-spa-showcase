module Update where

import Effects exposing (Effects)

import Model exposing (..)
import Routes as R

init : (Model, Effects Action)
init = (initialModel, Effects.none)

initialModel : Model
initialModel =
  { user = { name = "Tom" }
  , cities =
      { new = ""
      , actual =
          [ { name = "Paris" }
          , { name = "Nantes" }
          , { name = "Tokyo" }
          , { name = "Bouguenais" }
          ]
      }
  , route = R.Home
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    UpdateNewCity city ->
      let cities = model.cities
          newModel =
            { model
            | cities <- { cities | new <- city }
            }
      in  (newModel, Effects.none)
    AddNewCity ->
      let cities = model.cities
          newCity = { name = model.cities.new }
          newModel =
            { model
            | cities <-
                { cities
                | new <- ""
                , actual <- newCity :: cities.actual
                }
            }
      in  (newModel, Effects.none)
    DeleteCity city ->
      let cities = model.cities
          newModel =
            { model
            | cities <-
                { cities
                | actual <- List.filter ((/=) city << .name) model.cities.actual
                }
            }
      in  (newModel, Effects.none)
