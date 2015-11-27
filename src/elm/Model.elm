module Model where

type alias Model =
  { user : User
  , items : List Item
  }

type alias User =
  { name : String
  }

type alias Item =
  { name : String
  }

type Action = NoOp
