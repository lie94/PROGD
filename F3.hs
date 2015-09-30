-- Av Felix Hedenström och Jonathan Rinnarv
module Main where
import F2
import Data.List
import System.Environment

main = interact makeTree

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

get3rd (_,_,a) = a

helpTree :: [String] -> [[Double]] -> String
helpTree l m = 	if length l == 3 
				then "("++(l !! 0)++","++(l !! 1)++","++(l !! 2)++")"
				else res
						where
						ab = findAB 0 m 0 (length l) (-1) (-1)																--a)
						t1 = intercalate "" ["(",(l !! (ab !! 0)),",",(l !! (ab !! 1)),")"]								 	--b)
						l1 = getNewList (ab !! 0) (ab !! 1) t1 l 															--c)
						m1 = getNewDistM (ab !! 0) (ab !! 1) m
						res = show(m1)--helpTree l1 m1																		--d) 

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
													bl = findB index (index+1) length_leaves m lowest (-1)
													res = 	if (fst(bl)) == (-1) 
															then findAB (index + 1) m lowest length_leaves lA lB 
															else findAB (index + 1) m (snd(bl)) length_leaves index (fst(bl))

si :: Int -> Int -> Int -> [[Double]] -> Double 
si a b length_leaves dM = 	res
					where    		
					x = fromIntegral(length_leaves - 2) * (getValue a b dM) 
					sumF = sum [ (getValue a i dM) + (getValue b i dM) | i <- [0..(length_leaves - 1)]]
					res = x - sumF


getValue :: Int -> Int -> [[Double]] -> Double
getValue a b m 
				| a < b 			= (m !! a) !! (b - a)
				| otherwise 		= (m !! b) !! (a - b) 		

getNewList :: Int -> Int -> String -> [String] -> [String]
getNewList a b ts l = [	if (i == a) 
						then ts 
						else	l !! i | i <- [0..(length l - 1)], not(i == b)] 


						
-- The new index for the tree will be the same as the old index for a
--getNewDistM a b m = getNewDistMi a b m 0--[getInnerMatrix | i <- [0..(length m - 1)], not(i == b)]    
getNewDistM :: Int -> Int -> [[Double]] -> [[Double]]
getNewDistM a b m = getNewDistMi a b m 0

getNewDistMi:: Int -> Int -> [[Double]] -> Int -> [[Double]]
getNewDistMi a b m index
					| index > length m - 1 = []
					| index == b			= getNewDistMi a b m (index + 1)
					| otherwise 			= [(getInnerMatrix a b m index 0)]++getNewDistMi a b m (index + 1)

getInnerMatrix :: Int -> Int -> [[Double]] -> Int -> Int -> [Double]
getInnerMatrix a b m i index 
							| index > (length m - 1) - i   	= []
							| (index + i == b)				= []					  		++getInnerMatrix a b m i (index + 1)
							| index == 0					= [0]					  		++getInnerMatrix a b m i (index + 1)
							| (i == a) 						= [(getAverage a b (index+i) m 	)]++getInnerMatrix a b m i (index + 1)
							| (index + i == a) 				= [(getAverage a b (i) m 		)]++getInnerMatrix a b m i (index + 1)
							| otherwise 					= [(m !! i !! index)]++getInnerMatrix a b m i (index + 1) 

{-getNewDistM :: Int -> Int -> [[Double]] -> [[Double]]
getNewDistM old_a old_b old_matrix = if old_a == old_b then error("a == b, a = "++(show old_a))
 else [if i == old_a then ([0]++(getInnerMatrix old_a old_b old_matrix i) ) else getInnerMatrix old_a old_b old_matrix i | i <- [0..(length (old_matrix) - 1)], not(i == old_b)]

getInnerMatrix :: Int -> Int -> [[Double]] -> Int -> [Double]
getInnerMatrix old_a old_b old_matrix i = [ if (i == old_a || (j == old_a - i)) then (if i == old_a then  getAverage old_a old_b (j + i) old_matrix else getAverage old_a old_b i old_matrix)
						 else (old_matrix !! i) !! j |  j <- [0..(length(old_matrix !! i) - 1)], not(j == (old_b - i)) && not((j == 0) && (i == old_a))]-}

getAverage :: Int -> Int -> Int -> [[Double]] -> Double
getAverage a b c m = (getValue a c m + getValue b c m) / 2