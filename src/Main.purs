module Main where

import Prelude

import Data.Array (partition, null, any)
import Data.Traversable (traverse, traverse_)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import FFI.ReadDir (readDir, FileType(..), FileInfo)
import Node.Path (FilePath, concat)

defaultIgnores :: Array FilePath
defaultIgnores = ["dist", "output", "node_modules", ".spago", ".psci_modules"]

isFolder :: FileType -> Boolean
isFolder Folder = true
isFolder File = false

glob :: FilePath -> Array FilePath -> Aff (Array FileInfo)
glob path ignoring = do
  if any (path == _) ignoring then
    pure []
  else do
    let normalize other = concat $ [path, other]
    let normalizeFiles = map $ \file -> file { name = normalize file.name }
    { yes: folders, no: files } <- partition (isFolder <<< _.fileType) <$> readDir path
    nextFiles <- normalizeFiles <<< join <$> traverse (\folder -> glob (normalize folder.name) ignoring) folders
    pure $ normalizeFiles files <> nextFiles

main :: Effect Unit
main = launchAff_ do
  e <- glob "." defaultIgnores
  liftEffect $ traverse_ (\s -> log (s.name)) e

