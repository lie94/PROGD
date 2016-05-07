--Authors: 	Felix Hedenström 
-- 			Jonathan Rinnarv
module Main where
import Data.Char
import Data.Bool
import Data.List
import System.Environment

main = interact start

start :: String -> String
start s = 	res
			where
			a = words s
			width = read (a !! 0) :: Int
			--walls = a !! 1
			temp = 0:[read (a !! i) :: Int | i <- [2..(length a - 1)]]++[width]
			res = helpShow (sort (nub (chap temp temp))) --helpShow temp



helpShow :: [Int] -> String
helpShow [] = ""
helpShow (h:t) =  (show(h)++" ")++helpShow t


chap :: [Int] -> [Int] -> [Int]

chap [] _ = []
chap (h:t) static =  helpFunc h static ++chap t static


helpFunc :: Int -> [Int] -> [Int]
helpFunc a [] = []
helpFunc a (h:t) 
					| h < a 	= (a - h):helpFunc a t
					| otherwise = helpFunc a t 
