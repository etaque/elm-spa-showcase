module Routes where

import Router exposing (..)


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
  , dyn1 Topic "/topic/" intParam ""
  , dyn2 SubTopic "/topic/" intParam "/" intParam ""
  , dyn1 User "/user/" stringParam ""
  , static About "/about"
  ]


toUrl : Route -> Url
toUrl route =
  case route of
    Home -> "/"
    Topic a -> path [ "topic", toString a ]
    SubTopic a b -> path [ "topic", toString a, "subtopic", toString b ]
    User s -> path [ "user", s ]
    About -> "/about"
    NotFound -> "/404"
