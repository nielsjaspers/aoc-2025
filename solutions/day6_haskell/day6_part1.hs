module Main where

import System.CPUTime
import Data.List (transpose)
import Data.Function ((&))

main :: IO ()
main = do
    start <- getCPUTime
    input <- readFile "data/day6/day6.txt"
    let total = lines input
            & map words -- split the line into a list of words
            & transpose -- flip the matrix so that the columns are now rows
            & map processColumn
            & sum

    print total
    end <- getCPUTime
    let elapsedMs = fromIntegral (end - start) / 1000000000
    let elapsedUs = fromIntegral (end - start) / 1000000
    print $ show elapsedMs ++ " ms, " ++ show elapsedUs ++ " microseconds"

processColumn :: [String] -> Int
processColumn col = 
    let (numbers, [operator]) = splitAt (length col - 1) col -- split the column into a list of numbers and the operator
        nums = map read numbers :: [Int]
    in if operator == "+" then sum nums else product nums