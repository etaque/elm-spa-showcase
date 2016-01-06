module Main where

import Effects exposing (Never)
import Task
import Signal
import StartApp

import Action exposing (..)
import Update exposing (init, update)
import View exposing (view)
import Inputs exposing (actions)


port initialPath : String


app =
  StartApp.start
    { init = init initialPath
    , update = update
    , view = view
    , inputs = [ Inputs.actions ]
    }


main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
