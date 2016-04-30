-- Authors: 	Felix Hedenström
-- 				Jonathan Rinnarv

module Main where
import Data.Char
import Data.Bool
import Data.List
import System.Environment

main = interact helpCounter

helpCounter :: String -> String
helpCounter s = helpShow(counter s 0 0 0 0 0) 

helpShow :: [Double] -> String
helpShow [] = ""
helpShow (h:t) =  (show(h)++"\n")++helpShow t

-- Text - Whitespacecounter - lowercase - uppercase - symbol - total
counter :: [Char] -> Double -> Double -> Double -> Double -> Double -> [Double]
counter [] w l u s tot = [w / tot, l / tot, u / tot , s  / tot]
counter (h:t) w l u s tot 	
							| ord(h) == 10							= counter [] w l u s tot
							| ord(h) == 95 							= counter t (w + 1) l u s (tot + 1) 
							| (97 <= (ord(h))) && ((ord(h)) <= 122) = counter t w (l + 1) u s (tot + 1)
							| (65 <= (ord(h))) && ((ord(h)) <= 90)	= counter t w l (u + 1) s (tot + 1)
							| otherwise 							= counter t w l u (s + 1) (tot + 1)

--counter (h:t) w l u s tot = 	if h == '_' then counter t (w + 1) l u s tot
