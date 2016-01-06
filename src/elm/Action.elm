module Action where

import Signal
import TransitRouter

import Routes exposing (Route)
import Model exposing (..)
import Pages.Home.Model as Home
import Pages.Cities.Model as Cities


type Action =
  NoOp
  | RouterAction (TransitRouter.Action Route)
  | PageAction PageAction


type PageAction =
  PageNoOp
  | HomeAction Home.Action
  | CitiesAction Cities.Action

