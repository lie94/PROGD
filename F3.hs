-- Av Felix Hedenström och Jonathan Rinnarv
module Main where
import F2
import Data.List
import System.Environment

main = interact makeTree

si :: String -> String -> [String] -> [(String,String,Double)] -> Double 
si a b leaves dM = res
		where    		
		x = fromIntegral((length leaves) - 2) * (getValue a b dM) 
		sumF = sum [ (getValue a z dM) + (getValue b z dM) | z <- leaves]
		res = x - sumF


--90 % av tiden går åt detta

getValue :: String -> String -> [(String,String,Double)] -> Double
getValue a b [] = error ("Hittade inte ab: ("++(a)++", "++(b)++")") 
getValue a b (h:ms)
				| checkpair h a b = get3th h
				| otherwise = getValue a b ms

get3th (_,_,a) = a

checkpair :: (String,String,d) -> String -> String -> Bool 
checkpair (t1,t2,_) a b = ((a == t1) && (b == t2))  || ((b == t1) && (a == t2))
{-checkpair (t1,t2,_) a b 
						| ((t1 == a) || (t1 == b)) && ((t2 == a) || (t2 == b)) = True
						| otherwise = False-}
						

getNewDistM :: String -> String -> String -> [String] -> [(String,String,Double)] -> [(String,String,Double)] 
getNewDistM tree a b l m = res 
					where
					containsName s (a,b,_) = a == s || b == s
					res = [(tree, tree, 0)]++[if (containsName b t) then (tree,  (getNameTrip b t) , (getAvrage a b (getMolseq l (getNameTrip b t)) m)    ) else t  | t <- m , not(containsName a t) && not (getNameTrip b t == nullString)]

getMolseq :: [String] -> String -> String
getMolseq [] n = error ("Hittade inte någan molseq av typ: "++n)
getMolseq (h:xs) n = if h == n then h else getMolseq xs n

getNameTrip :: String -> (String,String,Double) -> String
getNameTrip b (f,s,_) 
					| b == f && b == s 			= nullString
					| b == s 					= f
					| otherwise 				= s

getAvrage :: String -> String -> String -> [(String,String,Double)] -> Double
getAvrage a b c m = (getValue a c m + getValue b c m) / 2

makeTree :: String -> String
makeTree s = res
	where
		l = words s
		lM = [string2seq (l !! (x - 1)) (l !! x ) | x <- [1,3..(length l - 1) ]]
		nM = distanceMatrix lM
		res = (helpTree (map name lM) nM)++['\n']

helpTree :: [String] -> [(String,String,Double)] -> String
helpTree l m = 	if length l == 3 then "("++(l !! 0)++","++(l !! 1)++","++(l !! 2)++")"
				else 	res
						where
						ab = findAB l m 0 l nullString nullString															--a)
						t1 = intercalate "" ["(",(ab !! 0),",",(ab !! 1),")"]								 	--b)
						l1 = getNewList (ab !! 0) (ab !! 1) t1 l 															--c)
						m1 = getNewDistM t1 (ab !! 0) (ab !! 1) l1 m														--d)
						res = helpTree l1 m1


getNewList :: String -> String -> String -> [String] -> [String]						
getNewList a b t l = [x | x <- l, not(x == a || x == b)]++[t]

nullString :: String
nullString = ""

--data TreeID = TreeID {id :: Int, name ::String}

findAB :: [String] -> [(String,String,Double)] -> Double -> [String] -> String -> String -> [String]
findAB [] _ _ _ lA lB = [lA, lB]
findAB (h:xs) m lowest leaves lA lB  = 	res
										where
										findB a [] leaf dm low lB = (lB,low)
										findB a (lh:lt) leaf dm low lB = 	result
																			where 
																			k = si a lh leaf dm
																			result = if k < low then findB a lt leaf dm k lh else findB a lt leaf dm low lB		
										bl = findB h xs leaves m lowest nullString
										res = if (fst(bl)) == nullString then findAB xs m lowest leaves lA lB else findAB xs m (snd(bl)) leaves h (fst(bl))
