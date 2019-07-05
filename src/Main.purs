module Main where

import Prelude

import Cli (convertIgnoreDir, runParser)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Glob (glob)
import Node.Path (FilePath)
import Token (getFileWithToken, handleOffense, readGitIgnore)

defaultIgnores :: Array FilePath
defaultIgnores =
  [ ".git"
  , "dist"
  , "output"
  , "node_modules"
  , ".spago"
  , ".psci_modules"
  ]

runChecker :: FilePath -> String -> Effect Unit
runChecker dest ignoreString = launchAff_ do
  let ignoring = convertIgnoreDir ignoreString
  gitIgnore <- readGitIgnore
  globbed <- glob dest $ gitIgnore <> defaultIgnores <> ignoring
  handleOffense =<< getFileWithToken globbed

main :: Effect Unit
main = launchAff_ $ runParser runChecker
  


