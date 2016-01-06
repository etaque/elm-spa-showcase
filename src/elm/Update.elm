module Update where

import Effects exposing (Effects, none)
import Response exposing (..)
import TransitRouter

import Model exposing (..)
import Action exposing (..)
import Routes exposing (..)

import Pages.Home.Update as Home
import Pages.Cities.Update as Cities


initialModel : Model
initialModel =
  { transitRouter = TransitRouter.empty EmptyRoute
  , user = { name = "" }
  , pages =
    { home = Home.initial
    , cities = Cities.initial
    }
  }


routerConfig : TransitRouter.Config Route Action Model
routerConfig =
  { mountRoute = mountRoute
  , getDurations = \_ _ _ -> (50, 200)
  , actionWrapper = RouterAction
  , routeDecoder = Routes.fromPath
  }


init : String -> Response Model Action
init path =
  TransitRouter.init routerConfig path initialModel


update : Action -> Model -> Response Model Action
update action model =
  case action of

    NoOp ->
      (model, none)

    RouterAction routeAction ->
      TransitRouter.update routerConfig routeAction model

    PageAction pageAction ->
      updatePage pageAction model.pages
        |> mapBoth (\pages -> { model | pages = pages }) PageAction


mountRoute : Route -> Route -> Model -> Response Model Action
mountRoute prevRoute route ({pages} as model) =
  mapBoth (\pages -> { model | pages = pages }) PageAction <|
    case route of

      Home ->
        Home.init
          |> mapBoth (\home -> { pages | home = home }) HomeAction

      Cities ->
        Cities.init
          |> mapBoth (\cities -> { pages | cities = cities }) CitiesAction

      _ ->
        res pages none


updatePage : PageAction -> Pages -> Response Pages PageAction
updatePage action pages =
  case action of

    HomeAction a ->
      Home.update a pages.home
        |> mapBoth (\home -> { pages | home = home }) HomeAction

    CitiesAction a ->
      Cities.update a pages.cities
        |> mapBoth (\cities -> { pages | cities = cities }) CitiesAction

    PageNoOp ->
      res pages none
