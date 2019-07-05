module Test.Main where

import Prelude

import Control.Monad.Free (Free)
import Data.Eq (eq1)
import Data.List (List(..), length, (:), all)
import Data.Maybe (isJust, isNothing, maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Glob (glob)
import Test.Unit (Test, TestF, suite, test)
import Test.Unit.Assert (assert)
import Test.Unit.Main (runTest)
import Token (fileHasTokenAt, hasToken, readFileString)

type Suite = Free TestF Unit

assertM :: String -> Aff Boolean -> Test
assertM onFail m = m >>= assert onFail

tokenSuite :: Suite
tokenSuite = do
  let expectedFileContent = "console.log(\"hello world\");\n"
  -- this one is reset, obviously... don't even bother
  let exampleToken = "Mzk1OTY5NjU0MjA1NDQ4MTky.XR2_jg.jQwvTCRO-fDatNHGG7gSfajZjzM"
  let exampleFileToken1 = fileHasTokenAt "./test/testReadFileToken.js"
  test "correct token matches" do
    assert "valid token not matching" $ hasToken exampleToken
  test "reads file content correctly" do
    assertM "invalid file content" $ (_ == expectedFileContent) <$> readFileString "./test/testReadFile.js"
  test "finds token in file" do
    assertM "token not detected" $ isJust <$> exampleFileToken1
  test "finds token in the right line" do
    assertM "token in the wrong file line" $ maybe false (_ == 11) <$> exampleFileToken1
  test "wrong tokens don't match" do
    assert "gibberish tokens detected as matching" <<< not $ hasToken "afgaskldhalwb.as.as"
  test "files without tokens don't match" do
    assertM "matching bad file" $ isNothing <$> fileHasTokenAt "./test/testReadFile.js"

globSuite :: Suite
globSuite = do
  let testTargets = "test/Main.purs" : "test/testReadFile.js" : "test/testReadFileToken.js" : Nil
  let ignoredFile = "Main.purs"
  let ignore = [ignoredFile]
  test "finds the correct files" do
    assertM "has wrong amount of files" do
      files <- glob "test" []
      pure $ length files == 3
  test "finds correct file names" do
    assertM "finds correct file names" do
      files <- map (_.name) <$> glob "test" []
      pure $ eq1 files testTargets
  test "ignores single file" do
    assertM "doesn't ignore correct files" do
      files <- map (_.name) <$> glob "test" ignore
      pure $ all (_ /= ignoredFile) files

main :: Effect Unit
main = runTest do
  test "sanity" do
    assert "I knew I wasn't crazy" $ (1 + 1) == 2
  suite "token" tokenSuite
  suite "glob" globSuite
  

      
  
  
