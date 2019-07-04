module Utility (lines, truthy) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), split)

lines :: String -> Array String
lines = split $ Pattern "\n"

truthy :: Maybe _ -> Boolean
truthy (Just _) = true
truthy Nothing = false