module Model where

import Time exposing (Time)

import ListComponent
import Routes exposing (Route)
import Transit


type alias Model = Transit.WithTransition
  { user : User
  , cities : Cities
  , route : Route
  , time : Time
  , page : Page
  }

type alias User =
  { name : String
  }

type alias Cities =
  { new : String
  , actual : ListComponent.Model City String
  }

type alias City =
  { name : String
  }

type Action =
  NoOp
  | UpdateTime Time
  | UpdateNewCity String
  | UpdateCities (ListComponent.Action City)
  | AddNewCity
  | DeleteCity City
  | LatestRoute (Maybe Route)
  | TransitAction (Transit.Action Model)
  | UpdateUrl String

type Page =
  Home
  | ShowTopic (Maybe Topic)
  | ShowUser (Maybe User)
  | About
  | NotFound

type alias Topic =
  { title : String
  }
