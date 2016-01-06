module Inputs where

import Action exposing (..)
import Signal exposing (..)
import TransitRouter


actions : Signal Action
actions =
  Signal.mergeMany
    [ Signal.map RouterAction TransitRouter.actions
    , mailbox.signal
    ]


mailbox : Mailbox Action
mailbox =
  Signal.mailbox NoOp


addr : Address Action
addr =
  mailbox.address


citiesAddr = pageForward CitiesAction
homeAddr = pageForward HomeAction


pageForward : (a -> PageAction) -> Signal.Address a
pageForward pageAction =
  Signal.forwardTo addr (pageAction >> PageAction)

