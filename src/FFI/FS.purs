module FFI.FS where

import Prelude

import Data.Array (toUnfoldable)
import Data.List (List)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Models (FileInfo, FileType(..))
import Node.Path (FilePath)

type FileInfo_ =
  { name :: FilePath
  , fileType :: String
  }

foreign import _readDir :: FilePath -> EffectFnAff (Array FileInfo_)

convertFileType :: String -> FileType
convertFileType "Folder" = Folder
convertFileType "File" = File
convertFileType _ = File

readDir :: FilePath -> Aff (List FileInfo)
readDir path = convert <<< toUnfoldable <$> fromEffectFnAff (_readDir path)
  where convert = map $ \file -> file { fileType = convertFileType file.fileType }