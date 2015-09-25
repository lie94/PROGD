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
{-getValue :: String -> String -> [(String,String,Double)] -> Double
getValue a b [] = error ("Hittade inte ab: ("++(a)++", "++(b)++")") 
getValue a b (h:ms)
				| checkpair h a b = get3rd h
				| otherwise = getValue a b ms-}

get3rd (_,_,a) = a

checkpair :: (String,String,d) -> String -> String -> Bool 
checkpair (t1,t2,_) a b = ((a == t1) && (b == t2))  || ((b == t1) && (a == t2))
{-checkpair (t1,t2,_) a b 
						| ((t1 == a) || (t1 == b)) && ((t2 == a) || (t2 == b)) = True
						| otherwise = False-}
						

{-getNewDistM :: String -> String -> String -> [String] -> [(String,String,Double)] -> [(String,String,Double)] 
getNewDistM tree a b l m = res 
					where
					containsName s (a,b,_) = a == s || b == s
					res = [(tree, tree, 0)]++[if (containsName b t) then (tree,  (getNameTrip b t) , (getAvrage a b (getMolseq l (getNameTrip b t)) m)    ) else t  | t <- m , not(containsName a t) && not (getNameTrip b t == nullString)]-}
-- The new index for the tree will be the same as the old index for a
getNewDistM :: Int -> Int -> [String] -> [[Double]] -> [[Double]]
getNewDistM old_a old_b list old_matrix = old_matrix --[         [ (old_matrix !! i )!! j ]          | i <- [0..(length old_matrix - 1)], j <- [0..(length (old_matrix !! i) - 1)], not(i == old_b) ]

getMolseq :: [String] -> String -> String
getMolseq [] n = error ("Hittade inte någan molseq av typ: "++n)
getMolseq (h:xs) n = if h == n then h else getMolseq xs n

getNameTrip :: String -> (String,String,Double) -> String
getNameTrip b (f,s,_) 
					| b == f && b == s 			= ""
					| b == s 					= f
					| otherwise 				= s

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
translateMatrix m l ol start = if ol == 0 then [] else (([[ get3rd (m !! i) | i <- [start..l - 1]]]) ++ (translateMatrix m (ol+l-1) (ol-1) l))

helpTree :: [String] -> [[Double]] -> String
helpTree l m = 	if length l == 3 then "("++(l !! 0)++","++(l !! 1)++","++(l !! 2)++")"
				else 	res
						where
						ab = findAB 0 m 0 (length l) (-1) (-1)																--a)
						t1 = intercalate "" ["(",(l !! (ab !! 0)),",",(l !! (ab !! 1)),")"]								 	--b)
						l1 = getNewList (ab !! 0) (ab !! 1) t1 l 															--c)
						m1 = getNewDistM (ab !! 0) (ab !! 1) l1 m														--d)
						res = {-"TESTBOYS: "++(show (ab !! 1))-}helpTree l1 m1


{-getNewList :: String -> String -> String -> [String] -> [String]						
getNewList a b t l = [x | x <- l, not(x == a || x == b)]++[t]-}
getNewList :: Int -> Int -> String -> [String] -> [String]
getNewList a b ts l = [if (i == a) then ts else	l !! i | i <- [0..(length l - 1)], not(i == b)] 

findAB :: Int -> [[Double]] -> Double -> Int -> Int -> Int -> [Int]   
findAB index m lowest length_leaves lA lB  = 	if index >= (length_leaves - 1 ) then [lA,lB] else res
												where
												findB a indexb length_leaf dm low bestB = 	if indexb > (length_leaf - 1 ) then (bestB,low) else result --Ändrat till indexb istället för index
																						where 
																						k = si a indexb length_leaf dm 							
																						result = if k < low then findB a (indexb + 1) length_leaf dm k indexb else findB a (indexb + 1) length_leaf dm low bestB --Ändrat till indexb istället för index		
												bl = findB index (index + 1) length_leaves m lowest (-1)
												res = if (fst(bl)) == (-1) then findAB (index + 1) m lowest length_leaves lA lB else findAB (index + 1) m (snd(bl)) length_leaves index (fst(bl))
