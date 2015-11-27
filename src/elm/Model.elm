module Model where

import Routes exposing (Route)

type alias Model =
  { user : User
  , cities : Cities
  , route: Route
  }

type alias User =
  { name : String
  }

type alias Cities =
  { new : String
  , actual : List City
  }

type alias City =
  { name : String
  }

type Action =
  NoOp
  | UpdateNewCity String
  | AddNewCity
  | DeleteCity String
