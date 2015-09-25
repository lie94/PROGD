-- Av Felix Hedenström och Jonathan Rinnarv
module Main where
import F2
import Data.List
import System.Environment

main = interact makeTree

si :: Int -> Int -> Int -> [[Double]] -> Double 
si a b length_leaves dM = 	res
					where    		
					x = fromIntegral( length_leaves - 2) * (getValue a b dM) 
					sumF = sum [ (getValue a i dM) + (getValue b i dM) | i <- [0..(length_leaves - 1)]]
					res = x - sumF


--90 % av tiden går åt detta

getValue :: Int -> Int -> [[Double]] -> Double
getValue a b m 
				| (a < b && (a > length m || ((b - a) > length(m !! a))))  || (b < a && (b > length m || ((a - b) > length (m !! b)))) = error ("A or B is larger than the possible indexes: A:"++show(a)++", B:"++show(b))
				| a < b 			= (m !! a) !! (b - a)
				| otherwise 		= (m !! b) !! (a - b) 		


get3rd (_,_,a) = a
						
-- The new index for the tree will be the same as the old index for a
getNewDistM :: Int -> Int -> [[Double]] -> [[Double]]
getNewDistM old_a old_b old_matrix = if old_a == old_b then error("a == b, a = "++(show old_a))
 else [if i == old_a then ([0]++(getInnerMatrix old_a old_b old_matrix i) ) else getInnerMatrix old_a old_b old_matrix i | i <- [0..(length (old_matrix) - 1)], not(i == old_b)] 
--old_matrix --[         [ (old_matrix !! i )!! j ]          | i <- [0..(length old_matrix - 1)], j <- [0..(length (old_matrix !! i) - 1)], not(i == old_b) ]
getInnerMatrix :: Int -> Int -> [[Double]] -> Int -> [Double]
getInnerMatrix old_a old_b old_matrix i 
						-- asdsdas |  i >= (length old_matrix) = error ("Index i: "++(show i)++" was to large.")
						| otherwise = [ if (i == old_a || (j == old_a - i)) then getAvrage old_a old_b j old_matrix
						 else (old_matrix !! i) !! j |  j <- [0..(length(old_matrix !! i) - 1)], not(j == (old_b - i)) && not((j == 0) && (i == old_a))]--not(j == old_b - old_a) && not( j == 0 && i == old_a)]

getAvrage :: Int -> Int -> Int -> [[Double]] -> Double
getAvrage a b c m = (getValue a c m + getValue b c m) / 2

makeTree :: String -> String
makeTree s = res
	where
		l = words s
		lM = [string2seq (l !! (x - 1)) (l !! x ) | x <- [1,3..(length l - 1) ]]
		nM = distanceMatrix lM
		m = translateMatrix nM (length lM) (length lM) 0
		res = (helpTree (map name lM) m)++['\n']

translateMatrix :: [(String,String,Double)] -> Int -> Int -> Int -> [[Double]]
translateMatrix m l ol start = 	if ol == 0 
								then [] 
								else (([[ get3rd (m !! i) | i <- [start..l - 1]]]) ++ (translateMatrix m (ol+l-1) (ol-1) l))

helpTree :: [String] -> [[Double]] -> String
helpTree l m= if length l == 3 then "("++(l !! 0)++","++(l !! 1)++","++(l !! 2)++")"
				else 	res
						where
						ab = findAB 0 m 0 (length l) (-1) (-1)																--a)
						t1 = intercalate "" ["(",(l !! (ab !! 0)),",",(l !! (ab !! 1)),")"]								 	--b)
						l1 = getNewList (ab !! 0) (ab !! 1) t1 l 															--c)
						m1 = getNewDistM (ab !! 0) (ab !! 1) m	
						res = 	if not((length l1) == (length (m1 !! 0))) 
								then error ("Length distance between distance matrix and string array. Matrix elements: "++(show (length(m1 !! 0)))++". List elemts: "++(show (length l1)))
								else (show (m1) )++helpTree l1 m1														--d) 
								--helpTree l1 m1
						--res = if not(length l1 == length m1) then error((show l1)++", "++(show m1)) else {-"TESTBOYS: "++(show (ab !! 1))-} helpTree l1 m1


{-getNewList :: String -> String -> String -> [String] -> [String]						
getNewList a b t l = [x | x <- l, not(x == a || x == b)]++[t]-}
getNewList :: Int -> Int -> String -> [String] -> [String]
getNewList a b ts l = [	if (i == a) 
						then ts 
						else	l !! i | i <- [0..(length l - 1)], not(i == b)] 

findAB :: Int -> [[Double]] -> Double -> Int -> Int -> Int -> [Int]   
findAB index m lowest length_leaves lA lB  = 	if index >= (length_leaves - 1 ) 
												then [lA,lB] 
												else res
													where
													findB a indexb length_leaf dm low bestB = 	if indexb > (length_leaf - 1 ) then (bestB,low) else result --Ändrat till indexb istället för index
																						where 
																						k = si a indexb length_leaf dm 							
																						result = 	if k < low 
																									then findB a (indexb + 1) length_leaf dm k indexb 
																									else findB a (indexb + 1) length_leaf dm low bestB --Ändrat till indexb istället för index		
													bl = findB index (index + 1) length_leaves m lowest (-1)
													res = 	if (fst(bl)) == (-1) 
															then findAB (index + 1) m lowest length_leaves lA lB 
															else findAB (index + 1) m (snd(bl)) length_leaves index (fst(bl))
