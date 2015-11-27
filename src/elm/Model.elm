module Model where

import Time exposing (Time)

import Routes exposing (Route)

type alias Model =
  { user : User
  , cities : Cities
  , route: Route
  , time: Time
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
  | UpdateTime Time
  | UpdateNewCity String
  | AddNewCity
  | DeleteCity String
