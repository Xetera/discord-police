module Models 
  ( FileType(..)
  , FileInfo(..)
  , FileSearchResult(..)
  , CommandInput
  ) where

import Data.Maybe (Maybe)
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

type CommandInput =
  { dir :: FilePath
  , ignore :: Maybe (Array FilePath)
  }