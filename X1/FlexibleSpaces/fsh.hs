--Authors: 	Felix Hedenström 
-- 			Jonathan Rinnarv
module Main where
import Data.Char
import Data.Bool
import Data.List
import System.Environment

main = interact start


-- Read the input and calculate all possible wall distances
start :: String -> String
start s = 	res
			where
			a = words s   -- Seperate the numbers into an array
			width = read (a !! 0) :: Int -- Read the first number, the maximum width of the room

			walls = 0:[read (a !! i) :: Int | i <- [2..(length a - 1)]]++[width] -- Read the rest of the numbers and save them as integers in an array, add 0 to the beginning and the width to the end
			res = helpString (sort (nub (chap walls walls)))    -- Removes duplicates and sorts the array, then turns it into a string 


-- Turns an array of ints into a string
helpString :: [Int] -> String
helpString [] = ""
helpString (h:t) =  (show(h)++" ")++helpString t

-- Iterates through all elements in the walls array from the start function. Static is a static version of this array, that contains all the elements from when the
-- function was first called.
chap :: [Int] -> [Int] -> [Int]

chap [] _ = []											-- If there are no element left 
chap (h:t) static =  helpFunc h static ++chap t static  -- Append the results from wall h

-- Combine wall a with every other possible wall and return the results.
helpFunc :: Int -> [Int] -> [Int]
helpFunc a [] = []
helpFunc a (h:t) 
					| h < a 	= (a - h):helpFunc a t -- The wall has to be smaller then a, otherwise the answer is negative.
					| otherwise = helpFunc a t 
