module Glob where

import Prelude

import Data.Array (any)
import Data.List (List(..), partition)
import Data.Traversable (traverse)
import Effect.Aff (Aff)
import FFI.FS (readDir)
import Models (FileType(..), FileInfo)
import Node.Path (FilePath, concat)

isFolder :: FileType -> Boolean
isFolder Folder = true
isFolder File = false

glob :: FilePath -> Array FilePath -> Aff (List FileInfo)
glob path ignoring = do
  if any (path == _) ignoring then
    pure Nil
  else do
    let normalize other = concat $ [path, other]
    let normalizeFiles = map $ \file -> file { name = normalize file.name }
    { yes: folders, no: files } <- partition (isFolder <<< _.fileType) <$> readDir path
    nextFiles <- join <$> traverse (\folder -> glob (normalize folder.name) ignoring) folders
    pure $ normalizeFiles files <> nextFiles