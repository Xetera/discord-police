module FFI.ReadDir (FileType(..), FileInfo, readDir) where

import Prelude
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Node.Path (FilePath)

data FileType
  = Folder
  | File

type FileInfo =
  { name :: FilePath
  , fileType :: FileType
  }

type FileInfo_ =
  { name :: FilePath
  , fileType :: String
  }
 
foreign import _readDir :: FilePath -> EffectFnAff (Array FileInfo_)

convertFileType :: String -> FileType
convertFileType "Folder" = Folder
convertFileType "File" = File
convertFileType _ = File

readDir :: FilePath -> Aff (Array FileInfo)
readDir path = convert <$> fromEffectFnAff (_readDir path)
  where convert = map $ \file -> file { fileType = convertFileType file.fileType }