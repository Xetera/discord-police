module Main where

import Prelude

import Cli (convertIgnoreDir, runParser)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Glob (glob)
import Models (FileSearchResult)
import Node.Path (FilePath)
import Test.Unit.Main (exit)
import Token (getFileWithToken, readGitIgnore)
import Utility (logError, logSuccess)

defaultIgnores :: Array FilePath
defaultIgnores =
  [ ".git"
  , "dist"
  , "output"
  , "node_modules"
  , ".spago"
  , ".psci_modules"
  ]

handleOffense :: Maybe FileSearchResult -> Aff Unit
handleOffense Nothing = do
  logSuccess "No token leak was detected"
  liftEffect $ exit 0
handleOffense (Just { file, position }) = do
  logError $ "A discord bot token was found in " <> file.name <> " on line " <> show position
  liftEffect $ exit 1


runChecker :: FilePath -> String -> Effect Unit
runChecker dest ignoreString = launchAff_ do
  let ignoring = convertIgnoreDir ignoreString
  gitIgnore <- readGitIgnore
  globbed <- glob dest $ gitIgnore <> defaultIgnores <> ignoring
  handleOffense =<< getFileWithToken globbed

main :: Effect Unit
main = launchAff_ $ runParser runChecker
  


