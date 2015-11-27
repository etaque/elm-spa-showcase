module Routes where

import Router as R exposing (..)

import Combine exposing (Parser, string, parse, end, andThen, many1, while, many, skip, maybe, Result (..))
import Combine.Char exposing (noneOf, char)
import Combine.Num exposing (int)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))


type Route
  = Home
  | Topic Int
  | SubTopic Int Int
  | User String
  | About
  | NotFound


routeParsers : List (Parser Route)
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
