module Routes where

import RouteParser exposing (..)


type Route
  = Home
  | Topic Int
  | SubTopic Int Int
  | User String
  | About
  | NotFound


routeParsers : Parsers Route
routeParsers =
  [ static Home "/"
  , dyn1 Topic "/topic/" int ""
  , dyn2 SubTopic "/topic/" int "/" int ""
  , dyn1 User "/user/" string ""
  , static About "/about"
  ]


toUrl : Route -> Url
toUrl route =
  case route of
    Home -> "/"
    Topic a -> "/topic/" ++ toString a
    SubTopic a b -> "/topic/" ++ toString a ++ "/" ++ toString b
    User s -> "/user/" ++ s
    About -> "/about"
    NotFound -> "/404"
