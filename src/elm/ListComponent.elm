module ListComponent
  ( Model
  , init
  , Action(..)
  , update
  , view
  ) where

import Html exposing (..)
import Signal exposing (Address)
import List
import Effects exposing (Effects)

-- MODEL

type alias Model a =
  { xs : List a
  }

init : List a -> Model a
init xs =
  { xs = xs
  }

-- UPDATE

type Action a =
  Add a
  | Delete a

update : Action a -> Model a -> (Model a, Effects (Action a))
update action model =
  case action of
    Add x ->
      let newModel = { model | xs <- x :: model.xs }
      in  (newModel, Effects.none)
    Delete x ->
      let newModel = { model | xs <- List.filter ((/=) x) model.xs }
      in  (newModel, Effects.none)

-- VIEW

view : Address (Action a) -> Model a -> (Address (Action a) -> a -> Html) -> Html
view address model renderElem =
  ul
    []
    (List.map (renderElem address) model.xs)
