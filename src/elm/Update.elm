module Update where

import Effects exposing (Effects)
import Time exposing (Time)
import History
import Task

import ListComponent
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
          ListComponent.init
            [ { name = "Paris" }
            , { name = "Nantes" }
            , { name = "Tokyo" }
            , { name = "Bouguenais" }
            ]
      }
  , route = R.Home
  , page = Home
  , pageStatus = Entered
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

    UpdateCities citiesAction ->
      let cities = model.cities
          (newActualCities, effects) = ListComponent.update citiesAction cities.actual
          newModel =
            { model
            | cities <- { cities | actual <- newActualCities }
            }
      in  (newModel, Effects.map UpdateCities effects)

    AddNewCity ->
      let cities = model.cities
          newCity = { name = model.cities.new }
          (newActualCities, effects) = ListComponent.update (ListComponent.Add newCity) cities.actual
          newModel =
            { model
            | cities <-
                { cities
                | new <- ""
                , actual <- newActualCities
                }
            }
      in  (newModel, Effects.map UpdateCities effects)
    UpdateUrl path ->
      (model, pushPath path)

    LatestRoute (Just route) ->
      let
        exitTransition = routeToPage route
          |> schedulePageEntering
          |> Effects.task
        newModel = { model | route <- route, pageStatus <- Exiting }
      in
        (newModel, exitTransition)

    LatestRoute Nothing ->
      ({ model | route <- R.NotFound, page <- NotFound }, Effects.none)

    PageAction pageAction ->
      case pageAction of
        StartPageEnter page ->
          let
            enterTransition = Effects.task schedulePageEntered
          in
            ({ model | page <- page, pageStatus <- Entering }, enterTransition)
        StopPageEnter ->
          ({ model | pageStatus <- Entered }, Effects.none)

routeToPage : R.Route -> Page
routeToPage route =
  case route of
    R.Home -> Home
    R.About -> About
    _ -> NotFound

schedulePageEntering : Page -> Task.Task x Action
schedulePageEntering page =
  Task.sleep 150 `Task.andThen`
    \_ -> Task.succeed (PageAction (StartPageEnter page))

schedulePageEntered : Task.Task x Action
schedulePageEntered =
  Task.sleep 150 `Task.andThen`
    \_ -> Task.succeed (PageAction StopPageEnter)

pushPath : String -> Effects Action
pushPath path =
  History.setPath path
    |> Task.map (\_ -> NoOp)
    |> Effects.task

currentRouteSignal : Signal Action
currentRouteSignal =
  Signal.map (LatestRoute << Router.match R.routeParsers) History.path
