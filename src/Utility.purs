module Utility 
  ( lines
  , bool
  , logError
  , logSuccess
  , formatLog
  ) where

import Prelude

import Ansi.Codes (Color(..))
import Ansi.Output (foreground, withGraphics)
import Data.String (Pattern(..), split)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)

lines :: String -> Array String
lines = split $ Pattern "\n"

bool :: forall a. a -> a -> Boolean -> a
bool a _ true  = a
bool _ b false = b

redColor :: String
redColor = "\\033[0;31m"

noColor :: String
noColor = "\\033[0m"

withColor :: Color -> String -> String
withColor color = withGraphics (foreground color)

formatLog ::String -> String -> String
formatLog prefix item = "[ Discord Police " <> prefix <> " ] " <> item

logError :: String -> Aff Unit
logError = liftEffect <<< log <<< withColor Red <<< formatLog "🚨" 

logSuccess :: String -> Aff Unit
logSuccess = liftEffect <<< log <<< withColor Green <<< formatLog "👮"
