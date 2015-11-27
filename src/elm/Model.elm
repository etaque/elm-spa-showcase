module Model where

import Routes exposing (Route)


type alias Model =
  { user : User
  , items : List Item
  , route: Route
  }

type alias User =
  { name : String
  }

type alias Item =
  { name : String
  }
type Action
  = NoOp
