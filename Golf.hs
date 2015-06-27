module Golf where

import Data.List

takeEveryNth :: Int -> [a] -> [a]
-- Why does left-to-right composition have a verbose operator? Pipe semantics
-- are awesome.
takeEveryNth n = takeEveryNth' . drop (n - 1) where
  -- Could have used a case.
  takeEveryNth' :: [a] -> [a]
  takeEveryNth' [] = []
  takeEveryNth' (x:ys) = x : takeEveryNth' (drop (n - 1) ys)

skips :: [a] -> [[a]]
skips xs = skips' 1 xs where
  skips' :: Int -> [a] -> [[a]]
  skips' m ys
    | m == length xs = [ys] -- Is length xs optimised out?
    | otherwise = takeEveryNth m ys : skips' (m + 1) ys

-- Alternative version.
skips'' :: [a] -> [[a]]
-- Need to remember A
skips'' l = map (f l) [1 .. length l] where
  f :: [a] -> Int -> [a]
  f l' n = case drop (n - 1) l' of
    (x:xs) -> x : f xs n
    [] -> []

localMaxima :: [Integer] -> [Integer]
localMaxima (a:b:c:rest)
  | a < b && b > c = b : localMaxima (c:rest)
  | otherwise = localMaxima $ b:c:rest
localMaxima _ = []

counts :: [Int] -> [Int]
counts xs = map (\x -> length $ elemIndices x xs) [0..9]

-- I knew the optimal solution would have transpose in it, I should have further
-- explored that line of reasoning. This solution is disgustingly iterative.
histogram :: [Int] -> String
histogram xs = histogram' (maximum (counts xs)) (counts xs)
               ++ "==========\n0123456789\n" where
  histogram' :: Int -> [Int] -> String
  histogram' 0 _ = ""
  histogram' n cs = map (\x -> if x == n then '*' else ' ') cs ++ "\n"
                    ++ histogram' (n - 1) (map (\x -> if x == n then x-1 else x) cs)
