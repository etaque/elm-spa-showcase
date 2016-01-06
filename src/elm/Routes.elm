module Routes where

import RouteParser exposing (..)


type Route
  = Home
  | Cities
  -- | Topic Int
  -- | SubTopic Int Int
  -- | User String
  | About
  | NotFound
  | EmptyRoute


routeParsers : List (Matcher Route)
routeParsers =
  [ static Home "/"
  , static Cities "/cities"
  -- , dyn1 Topic "/topic/" int ""
  -- , dyn2 SubTopic "/topic/" int "/" int ""
  -- , dyn1 User "/user/" string ""
  , static About "/about"
  ]


fromPath : String -> Route
fromPath path =
  RouteParser.match routeParsers path
    |> Maybe.withDefault NotFound


toPath : Route -> String
toPath route =
  case route of
    Home -> "/"
    Cities -> "/cities"
    -- Topic a -> "/topic/" ++ toString a
    -- SubTopic a b -> "/topic/" ++ toString a ++ "/" ++ toString b
    -- User s -> "/user/" ++ s
    About -> "/about"
    NotFound -> "/404"
    EmptyRoute -> ""
