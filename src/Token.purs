module Token (fileHasTokenAt, hasToken, getFileWithToken, handleOffense) where 

import Prelude

import Data.Array (findIndex)
import Data.Either (fromRight)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.String.Regex (Regex, test, regex)
import Data.String.Regex.Flags (RegexFlags, global, multiline)
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Models (FileInfo, FileSearchResult)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)
import Node.Path (FilePath)
import Partial.Unsafe (unsafePartial)
import Utility (lines, truthy)

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

fileHasTokenAt :: FilePath -> Aff (Maybe Int)
fileHasTokenAt file = findTokenIndex <<< lines <$> readFileString file

getFileWithToken :: List FileInfo -> Aff (Maybe FileSearchResult)
getFileWithToken Nil = pure Nothing
getFileWithToken (x:xs) = do
  tokenPosition <- fileHasTokenAt x.name
  case tokenPosition of
    Just position -> pure $ Just { file: x, position: position }
    Nothing -> getFileWithToken xs

handleOffense :: Maybe FileSearchResult -> Aff Unit
handleOffense Nothing = liftEffect $ log "No token leak was detected"
handleOffense (Just { file, position }) =
  liftEffect $ log ("[Token Leak Detected] A discord bot token was found in " <> file.name <> " on line number " <> show position)