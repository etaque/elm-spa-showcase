module Update where

import Effects exposing (Effects)
import Time exposing (Time)
import History
import Task

import Model exposing (..)
import Routes as R
import Router

init : Time -> (Model, Effects Action)
init time = (initialModel time, Effects.none)

initialModel : Time -> Model
initialModel time =
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
  , page = Home
  , time = time
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    UpdateTime time ->
      ({ model | time <- time}, Effects.none)
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
    UpdateUrl path ->
      (model, pushPath path)
    LatestRoute (Just route) ->
      ({ model | route <- route }, Effects.none)
    LatestRoute Nothing ->
      ({ model | route <- R.NotFound }, Effects.none)

pushPath : String -> Effects Action
pushPath path =
  History.setPath path
    |> Task.map (\_ -> NoOp)
    |> Effects.task

currentRouteSignal : Signal Action
currentRouteSignal =
  Signal.map (LatestRoute << Router.match R.routeParsers) History.path
