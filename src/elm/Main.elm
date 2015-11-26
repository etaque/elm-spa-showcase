
import Effects exposing (Never)
import StartApp
import Task

import Update exposing (init, update)
import View exposing (view)


app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
