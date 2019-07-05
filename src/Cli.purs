module Cli 
  ( runParser
  , convertIgnoreDir
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Foldable (fold)
import Data.String.Pattern (Pattern(..))
import Data.Maybe (Maybe(..))
import Data.String (split)
import Debug.Trace (traceM)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Node.Path (FilePath)
import Node.Yargs.Applicative (runY, yarg)
import Node.Yargs.Setup (YargsSetup, defaultHelp, defaultVersion, example, usage)

mainCommand :: YargsSetup
mainCommand = fold
  [ usage "$0 --ignore ignored,files"
  , example "$0 --ignore .env,secret_file" "Check files for possible discord token"
  , defaultVersion
  , defaultHelp
  ]

defaultPath :: FilePath
defaultPath = "."

convertIgnoreDir :: String -> Array FilePath
convertIgnoreDir = split $ Pattern ","

runParser :: (FilePath -> String -> Effect Unit) -> Aff Unit
runParser app = liftEffect <<< runY mainCommand $ app
  <$> yarg "dir" ["d"] (Just "target directory") (Left defaultPath) false
  <*> yarg "ignore" ["i"] (Just "ignore directories") (Left "") false
