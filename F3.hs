-- Av Felix Hedenström och Jonathan Rinnarv
module Main where
import Data.List
import System.Environment
import F2
--------------------------------------------------------------------------------
-- F3

data Tree = Branch MolSeq [Tree] | Leaf MolSeq
{-
-- leaves : Leaves
nj :: [Profile] -> [(String,String,Double)] -> Tree
nj leaves distansM = 	if length leaves > 3 then res
			where
		

findLowest :: 		Profile
findLowest a b leaves p lowestA lowestB =-}

si :: MolSeq -> MolSeq -> [MolSeq] -> [(String,String,Double)] -> Double 
si a b leaves dM = res
		where    		
		x = fromIntegral((length leaves) - 2) * (getValue a b dM) 
		sumF = sum [ (getValue a z dM) + (getValue b z dM) | z <- leaves]
		res = x - sumF

main = interact makeTree

getValue :: MolSeq -> MolSeq -> [(String,String,Double)] -> Double
getValue a b m = res 
				where
				get3th (_,_,a) = a
				checkpair (t1,t2,t3) a b = (t1 == name a && t2 == name b) || (t1 == name b && t2 == name a)
				res = get3th([ t | t <- m, (checkpair t a b) ] !! 0)

{-setValue :: MolSeq -> MolSeq -> [(String,String,Double)] -> Double -> [(String,String,Double)]
setValue a b m n = res   -- Det kan vara så att tripleten har ordningen på a och b fel 
				where 
				checkpair (t1,t2,t3) a b = (t1 == name a && t2 == name b) || (t1 == name b && t2 == name a)
				res = [if checkpair t a b then (name a, name b, n) else t | t <- m]-}

getNewDistM :: MolSeq -> MolSeq -> MolSeq -> [MolSeq] -> [(String,String,Double)] -> [(String,String,Double)] 
getNewDistM tree a b l m = res 
					where
					containsName s (a,b,_) = a == s || b == s
					res = [(name tree, name tree, 0)]++[if (containsName (name b) t) then ((name tree), (getNameTrip b t), (getAvrage a b (getMolseq l (getNameTrip b t))) m) else t  | t <- m , not(containsName (name a) t)]

getMolseq :: [MolSeq] -> String -> MolSeq
getMolseq [] n = error "Hittade inte någan molseq alls"
getMolseq (h:xs) n = if name h == n then h else getMolseq xs n

getNameTrip :: MolSeq -> (String,String,Double) -> String
getNameTrip b (f,s,_) = if name b == f then s else f

getAvrage :: MolSeq -> MolSeq -> MolSeq -> [(String,String,Double)] -> Double
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
						t1 = (Molseqconst ("("++(name (ab !! 0))++","++(name (ab !! 1))++")") "FELIX ÄR COOOOOOL" True) 	--b)
						l1 = getNewList (ab !! 0) (ab !! 1) t1 l 															--c)
						m1 = getNewDistM t1 (ab !! 0) (ab !! 1) l1 m														--d)
						res = helpTree l1 m1


getNewList :: MolSeq -> MolSeq -> MolSeq -> [MolSeq] -> [MolSeq]						
getNewList a b t l = [x | x <- l, not(name x == name a || name x == name b)]++[t]

nullMolSeq :: MolSeq
nullMolSeq = Molseqconst "NULL" "ACGT" True  


--si :: MolSeq -> MolSeq -> [MolSeq] -> [(String,String,Double)] -> Double
findAB :: [MolSeq] -> [(String,String,Double)] -> Double -> [MolSeq] -> MolSeq -> MolSeq -> [MolSeq] --INDEX TO LARGE					
findAB [] _ _ _ lA lB = [lA, lB]
findAB (h:xs) m lowest leaves lA lB =  	res						--if minimum(map si l xs m) < lowest then findAB xs m si
										where
										findB a [] leaf dm low lB = lB 
										findB a (lh:lt) leaf dm low lB = if si a lh leaf dm < low then findB a lt leaf dm (si a lh leaves dm) lh else findB a lt leaf dm low lB
										b = findB h xs leaves m lowest nullMolSeq
										res = if name b == "NULL" then findAB xs m lowest leaves lA lB else  findAB xs m (si h b leaves m) leaves h b