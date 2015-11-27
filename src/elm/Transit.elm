module Transit where

import Effects exposing (Effects)
import Task exposing (Task, andThen, sleep, succeed)
import Time exposing (Time)


type alias WithTransition page m =
  { m | transitStatus : Status, page : page }

type Status
  = Entering
  | Entered
  | Exiting

type Action page
  = StartEnter page
  | StopEnter
  | GoTo page


schedulePageEntering : Time -> page -> Task.Task x (Action page)
schedulePageEntering time page =
  delay time (succeed (StartEnter page))

schedulePageEntered : Time -> Task x (Action page)
schedulePageEntered time =
  delay time (succeed StopEnter)

delay : Time -> (Task error value) -> Task error value
delay time task =
  sleep time `andThen` \_ -> task

updateTransition : Time -> Action page -> WithTransition page m -> (WithTransition page m, Effects (Action page))
updateTransition time action model =
  case action of

    GoTo page ->
      let
        exitTransition = Effects.task (schedulePageEntering 150 page)
      in
        ({ model | transitStatus <- Exiting }, exitTransition)

    StartEnter page ->
      let
        enterTransition = Effects.task (schedulePageEntered time)
      in
        ({ model | page <- page, transitStatus <- Entering }, enterTransition)

    StopEnter ->
      ({ model | transitStatus <- Entered }, Effects.none)

isEntering : WithTransition m page -> Bool
isEntering model =
  model.transitStatus == Entering

isExiting : WithTransition m page -> Bool
isExiting model =
  model.transitStatus == Exiting
