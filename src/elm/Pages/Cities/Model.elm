module Pages.Cities.Model where

import ListComponent
import Time


type Action =
  NoOp
  | UpdateNew String
  | UpdateAll (ListComponent.Action City)
  | AddNew
  | Delete City


type alias Model =
  { new : String
  , actual : ListComponent.Model City String
  }

type alias City =
  { name : String
  }



