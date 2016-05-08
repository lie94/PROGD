-- Authors: 	Felix Hedenström
-- 				Jonathan Rinnarv

module Main where
import Data.Char
import Data.Bool
import Data.List
import System.Environment

main = interact helpCounter

-- Initiates the count of all types of symbols
helpCounter :: String -> String
helpCounter s = helpShow(counter s 0 0 0 0 0) 


-- Creates a string from all elements in an array of doubles
helpShow :: [Double] -> String
helpShow [] = ""
helpShow (h:t) =  (show(h)++"\n")++helpShow t

-- Text - Whitespacecounter - lowercase - uppercase - symbol - total

-- Recursivly counts all whitespaces, lowercases, uppercases, symbols as well as the total number of symbols
counter :: [Char] -> Double -> Double -> Double -> Double -> Double -> [Double]

-- If there are no more characters, calculate the procentage for each symbol
counter [] w l u s tot = [w / tot, l / tot, u / tot , s  / tot]

-- If there are characters to read, go through them one by one recursivly
counter (h:t) w l u s tot 	
							| ord(h) == 10							= counter [] w l u s tot   			-- The character is an end of line character, end the counting
							| ord(h) == 95 							= counter t (w + 1) l u s (tot + 1) -- The character is a whitespace-character, add one to both the whitespacecounter and the totalcounter
							| (97 <= (ord(h))) && ((ord(h)) <= 122) = counter t w (l + 1) u s (tot + 1)	-- The character is a lowercase-character, add one to both the lowercasecounter and the totalcounter
							| (65 <= (ord(h))) && ((ord(h)) <= 90)	= counter t w l (u + 1) s (tot + 1) -- The character is a uppercase-character, add one to both the uppercasecounter and the totalcounter
							| otherwise 							= counter t w l u (s + 1) (tot + 1) -- The character is a symbol-character, add one to both the symbolcounter and the totalcounter
