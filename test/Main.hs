module Main where

import Test.Tasty
import Test.Tasty.HUnit

import Data.Boolean

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Boolean"
  [ booleanClassTests
  , ifBTests
  , booleanFnTests
  , eqBTests
  , ordBTests
  , utilTests
  , tupleTests
  , maybeTests
  , functionTests
  ]

booleanClassTests :: TestTree
booleanClassTests = testGroup "Boolean class (Bool)"
  [ testCase "true == True"           $ (true  :: Bool) @?= True
  , testCase "false == False"         $ (false :: Bool) @?= False
  , testCase "notB True  == False"    $ notB True  @?= False
  , testCase "notB False == True"     $ notB False @?= True
  , testCase "True  &&* True  == True"  $ (True  &&* True)  @?= True
  , testCase "True  &&* False == False" $ (True  &&* False) @?= False
  , testCase "False &&* True  == False" $ (False &&* True)  @?= False
  , testCase "False &&* False == False" $ (False &&* False) @?= False
  , testCase "True  ||* True  == True"  $ (True  ||* True)  @?= True
  , testCase "True  ||* False == True"  $ (True  ||* False) @?= True
  , testCase "False ||* True  == True"  $ (False ||* True)  @?= True
  , testCase "False ||* False == False" $ (False ||* False) @?= False
  ]

ifBTests :: TestTree
ifBTests = testGroup "IfB"
  [ testCase "ifB True  selects first"  $ ifB True  (1 :: Int) 2 @?= 1
  , testCase "ifB False selects second" $ ifB False (1 :: Int) 2 @?= 2
  , testCase "ifB on Bool"              $ ifB True True False @?= True
  , testCase "ifB on Double"            $ ifB False (1.0 :: Double) 2.0 @?= 2.0
  ]

booleanFnTests :: TestTree
booleanFnTests = testGroup "boolean / cond / crop"
  [ testCase "boolean: condition last, True"  $ boolean (1 :: Int) 2 True  @?= 1
  , testCase "boolean: condition last, False" $ boolean (1 :: Int) 2 False @?= 2
  , testCase "guardedB: first match wins"     $
      guardedB True [(True, "yes"), (False, "no")] "default" @?= "yes"
  , testCase "guardedB: falls through to default" $
      guardedB True [(False, "no")] "default" @?= "default"
  , testCase "caseB: first matching predicate wins" $
      caseB (5 :: Int) [(> 3, "big"), (< 3, "small")] "medium" @?= "big"
  , testCase "caseB: falls through to default" $
      caseB (3 :: Int) [(> 3, "big"), (< 3, "small")] "medium" @?= "medium"
  ]

eqBTests :: TestTree
eqBTests = testGroup "EqB"
  [ testCase "1 ==* 1"          $ ((1 :: Int) ==* 1) @?= True
  , testCase "1 ==* 2 is False" $ ((1 :: Int) ==* 2) @?= False
  , testCase "1 /=* 2"          $ ((1 :: Int) /=* 2) @?= True
  , testCase "1 /=* 1 is False" $ ((1 :: Int) /=* 1) @?= False
  , testCase "EqB Char"         $ ('a' ==* 'a') @?= True
  ]

ordBTests :: TestTree
ordBTests = testGroup "OrdB"
  [ testCase "1 <*  2"          $ ((1 :: Int) <*  2) @?= True
  , testCase "2 <*  1 is False" $ ((2 :: Int) <*  1) @?= False
  , testCase "1 <=* 1"          $ ((1 :: Int) <=* 1) @?= True
  , testCase "1 <=* 2"          $ ((1 :: Int) <=* 2) @?= True
  , testCase "2 >*  1"          $ ((2 :: Int) >*  1) @?= True
  , testCase "1 >=* 1"          $ ((1 :: Int) >=* 1) @?= True
  , testCase "2 >=* 1"          $ ((2 :: Int) >=* 1) @?= True
  , testCase "OrdB Double"      $ ((1.5 :: Double) <* 2.5) @?= True
  ]

utilTests :: TestTree
utilTests = testGroup "minB / maxB / sort2B"
  [ testCase "minB 1 2 == 1"              $ minB (1 :: Int) 2 @?= 1
  , testCase "minB 2 1 == 1"              $ minB (2 :: Int) 1 @?= 1
  , testCase "maxB 1 2 == 2"              $ maxB (1 :: Int) 2 @?= 2
  , testCase "maxB 2 1 == 2"              $ maxB (2 :: Int) 1 @?= 2
  , testCase "sort2B (2,1) == (1,2)"      $ sort2B (2 :: Int, 1) @?= (1, 2)
  , testCase "sort2B (1,2) stays (1,2)"  $ sort2B (1 :: Int, 2) @?= (1, 2)
  , testCase "sort2B equal pair"         $ sort2B (3 :: Int, 3) @?= (3, 3)
  ]

tupleTests :: TestTree
tupleTests = testGroup "Tuple instances"
  [ testCase "ifB True  on pair selects first"  $
      ifB True  (1 :: Int, 2 :: Int) (3, 4) @?= (1, 2)
  , testCase "ifB False on pair selects second" $
      ifB False (1 :: Int, 2 :: Int) (3, 4) @?= (3, 4)
  , testCase "ifB on triple" $
      ifB True  (1 :: Int, 'a', True) (2, 'b', False) @?= (1, 'a', True)
  ]

maybeTests :: TestTree
maybeTests = testGroup "Maybe instance"
  [ testCase "ifB True  (Just 1) (Just 2) == Just 1" $
      ifB True  (Just (1 :: Int)) (Just 2) @?= Just 1
  , testCase "ifB False (Just 1) (Just 2) == Just 2" $
      ifB False (Just (1 :: Int)) (Just 2) @?= Just 2
  , testCase "ifB True  (Just 1) Nothing  == Just 1" $
      ifB True  (Just (1 :: Int)) Nothing  @?= Just 1
  , testCase "ifB False Nothing  (Just 2) == Just 2" $
      ifB False Nothing (Just (2 :: Int))  @?= Just 2
  ]

functionTests :: TestTree
functionTests = testGroup "Function instances"
  [ testCase "ifB on function: True branch applied" $
      (ifB True negate id :: Int -> Int) 5 @?= -5
  , testCase "ifB on function: False branch applied" $
      (ifB False negate id :: Int -> Int) 5 @?= 5
  , testCase "Boolean on function: notB" $
      (notB (> 3) :: Int -> Bool) 5 @?= False
  , testCase "Boolean on function: &&*" $
      ((> 0) &&* (< 10) :: Int -> Bool) 5 @?= True
  , testCase "Boolean on function: &&* both needed" $
      ((> 0) &&* (< 10) :: Int -> Bool) 15 @?= False
  ]
