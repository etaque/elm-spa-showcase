module Pages.Cities.Update where

import Effects exposing (Effects, none)
import Time

import ListComponent

import Inputs exposing (citiesAddr)
import Pages.Cities.Model exposing (..)


init : (Model, Effects Action)
init =
  (initial, none)


initial : Model
initial =
  { new = ""
  , actual =
      ListComponent.init
        [ { name = "Paris" }
        , { name = "Nantes" }
        , { name = "Tokyo" }
        , { name = "Bouguenais" }
        ]
        (1 * Time.second)
        (\x -> x.name)
  }


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    NoOp ->
      (model, none)

    UpdateNew city ->
      ({ model | new = city }, none)

    UpdateAll citiesAction ->
      let
        (newActualCities, effects) = ListComponent.update citiesAction model.actual
        newModel = { model | actual = newActualCities }
      in
        (newModel, Effects.map UpdateAll effects)

    AddNew ->
      let
        newCity = { name = model.new }
        (newActualCities, effects) = ListComponent.update (ListComponent.Add newCity) model.actual
        newModel =
          { model | new = "", actual = newActualCities }
      in
        (newModel, Effects.map UpdateAll effects)

    Delete c ->
      (model, none)
