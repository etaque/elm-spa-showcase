module Model where

import TransitRouter exposing (WithRoute)

import Routes exposing (Route)
import Pages.Home.Model as Home
import Pages.Cities.Model as Cities


type alias Model = WithRoute Route
  { user : User
  , pages : Pages
  }

type alias User =
  { name : String
  }

type alias Pages =
  { home : Home.Model
  , cities : Cities.Model
  }

type alias Topic =
  { title : String
  }

