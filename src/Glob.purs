module Glob where

import Prelude

import Data.Array (all, any)
import Data.List (List(..), filter, partition)
import Data.Traversable (traverse)
import Effect.Aff (Aff)
import FFI.FS (readDir)
import Models (FileType(..), FileInfo)
import Node.Path (FilePath, concat)

isFolder :: FileType -> Boolean
isFolder Folder = true
isFolder File = false

-- | Recursively grab a list of all files inside a directory
-- | Ignores directories and paths that match the ignore array
glob :: FilePath -> Array FilePath -> Aff (List FileInfo)
glob path ignoring
  | any (_ == path) ignoring = pure Nil
  | otherwise = do
    let normalize other = concat $ [path, other]
    let normalizeFiles = map $ \file -> file { name = normalize file.name }
    { yes: folders, no: files } <- partition (isFolder <<< _.fileType) <$> readDir path
    let filteredFiles = filter (not <<< isIgnoring) $ normalizeFiles files
    nextFiles <- join <$> traverse (\folder -> glob (normalize folder.name) ignoring) folders
    pure $ filteredFiles <> nextFiles
      where
        isIgnoring target = any (_ == target.name) ignoring