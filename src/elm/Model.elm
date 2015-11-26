module Model where

type alias Model = { user: User }
type alias User = { name: String }

type Action = NoOp

