module Token
  ( fileHasTokenAt
  , tokenRegex
  , hasToken
  , readFileString
  , getFileWithToken
  , handleOffense
  , readGitIgnore
  ) where

import Prelude

import Data.Array (findIndex)
import Data.Either (fromRight)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.String.Regex (Regex, test, regex)
import Data.String.Regex.Flags (RegexFlags, global, multiline)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Models (FileInfo, FileSearchResult)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (exists, readTextFile)
import Node.Path (FilePath)
import Node.Process (exit)
import Partial.Unsafe (unsafePartial)
import Utility (bool, lines, logError, logSuccess)

tokenFlags :: RegexFlags
tokenFlags = global <> multiline

tokenRegex :: Regex
tokenRegex = unsafePartial fromRight $ regex "[MN][A-Za-z\\d]{23}\\.[\\w-]{6}\\.[\\w-]{27}" tokenFlags

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

handleOffense :: Maybe FileSearchResult -> Aff Unit
handleOffense Nothing = do
  logSuccess "No token leak was detected"
  liftEffect $ exit 0

handleOffense (Just { file, position }) = do
  logError $ "A discord bot token was found in " <> file.name <> " on line " <> show position
  liftEffect $ exit 1

readGitIgnore :: Aff (Array String)
readGitIgnore = bool (lines <$> readFileString target) (pure []) =<< exists target
  where target = ".gitignore"