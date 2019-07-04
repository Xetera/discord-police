module Models (FileType(..), FileInfo(..), FileSearchResult(..)) where

import Node.Path (FilePath)

data FileType
  = Folder
  | File

type FileInfo =
  { name :: FilePath 
  , fileType :: FileType
  }

type FileSearchResult = 
  { file :: FileInfo
  , position :: Int
  }