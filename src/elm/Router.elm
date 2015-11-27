module Router (path, pathMaybe, intParam, maybeIntParam, stringParam, static, dyn1, dyn2, dyn3, match, Url, Parsers) where

import Combine exposing (Parser, string, parse, end, andThen, many1, while, many, skip, maybe, Result (..))
import Combine.Char exposing (noneOf, char)
import Combine.Num exposing (int)
import Combine.Infix exposing ((<$>), (<$), (<*), (*>), (<*>), (<|>))

import Maybe
import String
import List


type alias Url = String
type alias Parsers route = List (Parser route)


intParam : Parser Int
intParam = int

maybeIntParam : Parser (Maybe Int)
maybeIntParam =
  maybe (string "/" *> int)

stringParam : Parser String
stringParam = stringPart

path : List String -> Url
path items =
  List.map (\s -> "/" ++ s) items
    |> String.concat

pathMaybe : List (Maybe String) -> Url
pathMaybe items =
  items
    |> List.filterMap identity
    |> path

static : route -> String -> Parser route
static route path =
  route <$ (string path *> end)

dyn1 : (a -> route) -> String -> Parser a -> String -> Parser route
dyn1 route s1 pa s2 =
  route <$> (string s1 *> pa) <* string s2 <* end

dyn2 : (a -> b -> route) -> String -> Parser a -> String -> Parser b -> String -> Parser route
dyn2 route s1 pa s2 pb s3 =
  route <$> ((string s1 *> pa)) `andThen`
    (\r -> r <$> (string s2 *> pb <* string s3 <* end))

dyn3 : (a -> b -> c -> route) -> String -> Parser a -> String -> Parser b -> String -> Parser c -> String -> Parser route
dyn3 route s1 pa s2 pb s3 pc s4 =
  route <$> ((string s1 *> pa)) `andThen`
    (\r -> r <$> (string s2 *> pb)) `andThen`
    (\r -> r <$> (string s3 *> pc <* string s4 <* end))

{-| Parse a part of an url path
  "foo/bar" => Done "foo"
  "foo#baz" => Done "foo"
  "foo?baz" => Done "foo"
  "/foo" => Fail (...)
  "" => Fail (...)
-}
stringPart : Parser String
stringPart =
  String.fromList <$> many1 (noneOf [ '/', '#', '?' ])


match : List (Parser route) -> Url -> Maybe route
match parsers url =
  List.foldl (matchUrl url) Nothing parsers


matchUrl : Url -> Parser route -> Maybe route -> Maybe route
matchUrl url parser maybeRoute =
  case maybeRoute of
    Just _ ->
      maybeRoute
    Nothing ->
      case parse parser url of
        (Done route, _) ->
          Just route
        _ ->
          Nothing


