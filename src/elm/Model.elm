module Model where

import Time exposing (Time)

import Routes exposing (Route)

type alias Model =
  { user : User
  , cities : Cities
  , route : Route
  , time : Time
  , page : Page
  , pageStatus : PageStatus
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
  | LatestRoute (Maybe Route)
  | PageAction PageAction
  | UpdateUrl String


type Page
  = Home
  | ShowTopic (Maybe Topic)
  | ShowUser (Maybe User)
  | About
  | NotFound


type PageStatus
  = Entering
  | Entered
  | Exiting

type PageAction
  = StartPageEnter Page
  | StopPageEnter

type alias Topic =
  { title : String
  }
