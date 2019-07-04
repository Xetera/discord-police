module Main where

import Prelude

import Data.List (filterM)
import Data.List.NonEmpty (foldM)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (traverse)
import Debug.Trace (traceM)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Glob (glob)
import Node.Path (FilePath)
import Node.Process (exit)
import Token (fileHasTokenAt, getFileWithToken, handleOffense, hasToken)
import Utility (truthy)

defaultIgnores :: Array FilePath
defaultIgnores = [".git", "dist", "output", "node_modules", ".spago", ".psci_modules"]

main :: Effect Unit
main = launchAff_ do
  globbed <- glob "src" defaultIgnores
  offending <- getFileWithToken globbed
  handleOffense offending

