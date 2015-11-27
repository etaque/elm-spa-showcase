import Effects exposing (Never)
import StartApp
import Task
import Time exposing (every, Time)
import Signal

import Model exposing (Action(UpdateTime))
import Update exposing (init, update, currentRouteSignal)
import View exposing (view)
import Routes

app =
  StartApp.start
    { init = init time
    , update = update
    , view = view
    , inputs =
       [ Signal.map UpdateTime (every 100)
       , currentRouteSignal
       ]
    }

main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

port time : Time
