module Token
  ( fileHasTokenAt
  , tokenRegex
  , hasToken
  , readFileString
  , getFileWithToken
  , readGitIgnore
  ) where

import Prelude

import Data.Array (findIndex)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.String.Regex (Regex, test)
import Data.String.Regex.Flags (RegexFlags, global, multiline)
import Data.String.Regex.Unsafe (unsafeRegex)
import Effect.Aff (Aff)
import Models (FileInfo, FileSearchResult)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (exists, readTextFile)
import Node.Path (FilePath)
import Utility (bool, lines)

tokenFlags :: RegexFlags
tokenFlags = global <> multiline

tokenRegex :: Regex
tokenRegex = unsafeRegex "[MN][A-Za-z\\d]{23}\\.[\\w-]{6}\\.[\\w-]{27}" tokenFlags

hasToken :: String -> Boolean
hasToken = test tokenRegex

readFileString :: FilePath -> Aff String
readFileString = readTextFile UTF8

findTokenIndex :: Array String -> Maybe Int
findTokenIndex fileLines = (_ + 1) <$> findIndex hasToken fileLines

-- | Returns the line number the file has a token in
-- | If the file does not have a token, returns Nothing
fileHasTokenAt :: FilePath -> Aff (Maybe Int)
fileHasTokenAt file = findTokenIndex <<< lines <$> readFileString file

-- | Finds the first file in a list of files that has a token in it
getFileWithToken :: List FileInfo -> Aff (Maybe FileSearchResult)
getFileWithToken Nil = pure Nothing
getFileWithToken (x:xs) = do
  tokenPosition <- fileHasTokenAt x.name
  case tokenPosition of
    Just position -> pure $ Just { file: x, position: position }
    Nothing -> getFileWithToken xs

readGitIgnore :: Aff (Array String)
readGitIgnore = bool (lines <$> readFileString target) (pure []) =<< exists target
  where target = ".gitignore"