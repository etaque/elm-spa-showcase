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
import Time exposing (Time, second)
import Dict exposing (Dict)

-- MODEL

type alias Model a comparable =
  { xs : List a
  , deleteAnimations : Dict comparable DeleteAnimation
  , getId : a -> comparable
  , deleteDuration : Time
  }

type alias DeleteAnimation =
  { elapsedTime : Time
  , prevTime : Time
  }

init : List a -> Time -> (a -> comparable) -> (Model a comparable)
init xs deleteDuration getId =
  { xs = xs
  , deleteAnimations = Dict.empty
  , getId = getId
  , deleteDuration = deleteDuration
  }

-- UPDATE

type Action a =
  Add a
  | Delete a
  | Deleting a Time

update : Action a -> Model a comparable -> (Model a comparable, Effects (Action a))
update action model =
  case action of
    Add x ->
      let newModel = { model | xs <- x :: model.xs }
      in  (newModel, Effects.none)
    Delete x ->
      case Dict.get (model.getId x) model.deleteAnimations of
        Just _ ->
          (model, Effects.none)
        Nothing ->
          (model, Effects.tick (Deleting x))
    Deleting x time ->
      let newElapsedTime =
            case Dict.get (model.getId x) model.deleteAnimations of
              Just deleting -> deleting.elapsedTime + (time - deleting.prevTime)
              Nothing -> 0
      in  if newElapsedTime > model.deleteDuration
            then
              ( { model
                | xs <- List.filter ((/=) x) model.xs
                , deleteAnimations <- Dict.remove (model.getId x) model.deleteAnimations
                }
              , Effects.none
              )
            else
              let deleteAnimation =
                    { elapsedTime = newElapsedTime
                    , prevTime = time
                    }
              in  ( { model | deleteAnimations <- Dict.update (model.getId x) (\_ -> Just deleteAnimation) model.deleteAnimations}
                  , Effects.tick (Deleting x)
                  )

find : a -> List a -> Maybe a
find x xs =
  case List.filter ((==) x) xs of
    elem :: _ -> Just elem
    [] -> Nothing

-- VIEW

view : Address (Action a) -> Model a comparable -> (Address (Action a) -> Float -> a -> Html) -> Html
view address model renderElem =
  ul
    []
    (List.map (\x -> renderElem address (deleteStep model x) x) model.xs)

deleteStep : Model a comparable -> a -> Float
deleteStep model x =
  case Dict.get (model.getId x) model.deleteAnimations of
    Just deleting ->
      1.0 - deleting.elapsedTime / model.deleteDuration
    Nothing ->
      1.0
