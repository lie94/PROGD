-- Av Felix Hedenström och Jonathan Rinnarv
module Main where
import F2
import Data.List
import System.Environment

main = interact makeTree

si :: String -> MolSeq -> [MolSeq] -> [(String,String,Double)] -> Double 
si a b leaves dM = res
		where 
		nameB = (name b)   		
		x = fromIntegral((length leaves) - 2) * (getValue a nameB dM) 
		sumF = sum [ (getValue a z dM) + (getValue nameB z dM) | z <- (map name leaves)]
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
						

getNewDistM :: MolSeq -> MolSeq -> MolSeq -> [MolSeq] -> [(String,String,Double)] -> [(String,String,Double)] 
getNewDistM tree a b l m = res 
					where
					containsName s (a,b,_) = a == s || b == s
					nameT = name tree
					nameA = name a
					nameB = name b
					res = [(nameT, nameT, 0)]++[if (containsName nameB t) then ((nameT),  (getNameTrip b t), (getAvrage nameA nameB (name (getMolseq l (getNameTrip b t)))) m) else t  | t <- m , not(containsName (nameA) t) && not (length (getNameTrip b t) == 0)]

getMolseq :: [MolSeq] -> String -> MolSeq
getMolseq [] n = error ("Hittade inte någan molseq av typ: "++n)
getMolseq (h:xs) n = if name h == n then h else getMolseq xs n

getNameTrip :: MolSeq -> (String,String,Double) -> String
getNameTrip b (f,s,_) 
					| name b == f && name b == s 	= ""
					| name b == s 					= f
					| otherwise 					= s

getAvrage :: String -> String -> String -> [(String,String,Double)] -> Double
getAvrage a b c m = (getValue a c m + getValue b c m) / 2

makeTree :: String -> String
makeTree s = res
	where
		l = words s
		lM = [string2seq (l !! (x - 1)) (l !! x ) | x <- [1,3..(length l - 1) ]]
		nM = distanceMatrix lM
		res = (helpTree lM nM)++['\n']

helpTree :: [MolSeq] -> [(String,String,Double)] -> String
helpTree l m = 	if length l == 3 then "("++(name (l !! 0))++","++(name (l !! 1))++","++(name (l !! 2))++")"
				else 	res
						where
						ab = findAB l m 0 l nullMolSeq nullMolSeq															--a)
						t1 = (Molseqconst (intercalate "" ["(",(name (ab !! 0)),",",(name (ab !! 1)),")"]) "FELIX ÄR COOOOOOL" True) 	--b)
						l1 = getNewList (ab !! 0) (ab !! 1) t1 l 															--c)
						m1 = getNewDistM t1 (ab !! 0) (ab !! 1) l1 m														--d)
						res = helpTree l1 m1


getNewList :: MolSeq -> MolSeq -> MolSeq -> [MolSeq] -> [MolSeq]						
getNewList a b t l = [x | x <- l, not(name x == name a || name x == name b)]++[t]

nullMolSeq :: MolSeq 
nullMolSeq = Molseqconst "" "ACGT" True  


{-findAB :: [MolSeq] -> [(String,String,Double)] -> Double -> [MolSeq] -> MolSeq -> MolSeq -> [MolSeq] --INDEX TO LARGE					
findAB [] _ _ _ lA lB = [lA, lB]
findAB (h:xs) m lowest leaves lA lB =  	res						--if minimum(map si l xs m) < lowest then findAB xs m si
										where
										findB a [] leaf dm low lB = lB 
										findB a (lh:lt) leaf dm low lB = if si a lh leaf dm < low then findB a lt leaf dm (si a lh leaves dm) lh else findB a lt leaf dm low lB
										b = findB h xs leaves m lowest nullMolSeq
										res = if length (name b) == 0 then findAB xs m lowest leaves lA lB else  findAB xs m (si h b leaves m) leaves h b-}
findAB :: [MolSeq] -> [(String,String,Double)] -> Double -> [MolSeq] -> MolSeq -> MolSeq -> [MolSeq]
findAB [] _ _ _ lA lB = [lA, lB]
findAB (h:xs) m lowest leaves lA lB  = 	res
										where
										nameH = name h
										findB a [] leaf dm low lB = (lB,low)
										findB a (lh:lt) leaf dm low lB = 	result
																			where 
																			k = si a lh leaf dm
																			result = if k < low then findB a lt leaf dm k lh else findB a lt leaf dm low lB		
										bl = findB nameH xs leaves m lowest nullMolSeq
										res = if length (name (fst(bl))) == 0 then findAB xs m lowest leaves lA lB else findAB xs m (snd(bl)) leaves h (fst(bl))
