-- Av Felix Hedenström och Jonathan Rinnarv
module F3 where
import Data.List
import System.Environment
--data Evol = MolSeq | Profile
--distance :: Evol -> Evol -> Double
class Evol a where	-- Evol är en typklass ´
	distance :: a -> a -> Double
	name :: a -> String
	isDNA :: a -> Bool
	--nj :: [a] -> [(String,String,Double)] -> Tree 
	--nj evolM distM = 
	distanceMatrix :: [a] -> [(String,String,Double)]
	distanceMatrix l = [ ((name (l !! i)) ,(name (l !! j)),(distance (l !! i) (l !! j))	) | i <- [0..(length l - 1)]   , j <- [i..(length l - 1)]  ]--, i <= j]
	

instance Evol MolSeq where --Om Evol är MolSeq
	distance = seqDistance
	name = seqName
	isDNA = isDNAM

instance Evol Profile where	--Om Evol är ProfleBool
	distance = profileDistance
	name = profileName
	isDNA = isDNAP

-- Profileconst
data Profile = Profileconst [[(Char, Int)]] Bool Int String   -- M, DNA eller inte, Hur många sekvenser den är byggd av, Namnet på Profileconstn

data MolSeq = Molseqconst String String Bool -- If it's DNA, the bool should be True

string2seq :: String -> String -> MolSeq
string2seq n s = if isACGT(s) then (Molseqconst n s True)
		else (Molseqconst n s False)

-- Check if string only contains ACGT
isACGT :: String -> Bool
isACGT [] = True -- Kanske bör ändras till isACGT (x:[]) = True
isACGT (a:s) = if (elem a "ACGT") then isACGT(s)
		else False  

seqName :: MolSeq -> String
seqName (Molseqconst n _ _) = n

seqSequence :: MolSeq -> String
seqSequence (Molseqconst _ s _) = s 

-- Checks if a Molseqconst is of type DNA
isDNAM :: MolSeq -> Bool
isDNAM (Molseqconst _ _ b) = b

isDNAP :: Profile -> Bool -- isDNA for Profileconsts
isDNAP (Profileconst _ b _ _) = b

seqLength :: MolSeq -> Int
seqLength (Molseqconst _ s _) = length s 

seqDistance :: MolSeq -> MolSeq -> Double
seqDistance (Molseqconst _ s0 b0) (Molseqconst _ s1 b1) = if not (b0 == b1) then error "The Molseqconst:s was not of the same types"
		else formulaCheck b0 ((seqDistanceHelp s0 s1 0 ) / fromIntegral(length s0)) -- Väljer vilken formel som ska användas beroend på om det är DNA eller Protein och kallar på den.

seqDistanceHelp :: String -> String -> Double -> Double
seqDistanceHelp [] [] notMatches = notMatches
seqDistanceHelp (h0:s0) (h1:s1) notMatches = if not (h0 == h1) then seqDistanceHelp s0 s1 (notMatches + 1) --Kollar antalet icke matches och returnerar svaret. 
else seqDistanceHelp s0 s1 notMatches

-- Chooses the correct formula depending on if the 
formulaCheck :: Bool -> Double -> Double
formulaCheck b alfa 
		| b && alfa < 0.74 = (- 3 / 4 ) * log (1 - 4 * alfa / 3)  -- If it's DNA and alfa is less than 0.74, use Jules-Cantors formula
		| b = 3.3  	-- If it's DNA and larger than 0.74 then set it to 3.3
		| alfa <= 0.94 = (-19 / 20) * log(1 - 20 * alfa / 19) -- If it's a Protein and alfa is less than or equal to 0.94, return the answer with the help of the Poisson model
		| otherwise = 3.7 --Otherwise return 3.7


profileName :: Profile -> String
profileName (Profileconst _ _ _ s) = s

proMat :: Profile -> [[(Char, Int)]]
proMat (Profileconst m _ _ _) = m

proLen :: Profile -> Int
proLen (Profileconst _ _ r _) = r

--profileDistance :: Profile -> Profile -> Double

profileFrequency :: Profile -> Int -> Char -> Double
profileFrequency p i c = fromIntegral((search((proMat p) !! i) c))/(fromIntegral(proLen p)) --Returnerar antal matchers i sekvensraden delat på antal sekvenser
	where
		search (h:t) c
			|	fst(h) == c = snd(h)
			|	otherwise = search t c
		search [] _ = 0


molseqs2profile :: String -> [MolSeq] -> Profile
molseqs2profile n ma = (Profileconst (makeProfileMatrix ma) (isDNA(ma !! 0)) (length ma) n)

-- KODSKELLET
nucleotides = "ACGT"
aminoacids = sort "ARNDCEQGHILKMFPSTWYVX"

makeProfileMatrix :: [MolSeq] -> [[(Char, Int)]]
makeProfileMatrix [] = error "Empty_sequence_list"
makeProfileMatrix s1 = res
	where
	t = isDNA(head s1)
	defaults = 
		if t then
			zip nucleotides (replicate (length nucleotides) 0)  -- Rad (i)
		else
			zip aminoacids (replicate (length aminoacids) 0)    -- Rad (ii)
	strs = map seqSequence s1 
	tmp1 = map ( map ( \x -> ((head x), (length x))) . group . sort) (transpose strs) -- Använder en lambda funktion till att göra doublets med en bokstav och hur många instanser av bokstaven som finns 
		-- ACGT   
		-- CCGT
		-- CTGT
	-- map f(g(x)) m
	equalFst a b = (fst a) == (fst b) -- Hjälpfunktion
	res = map sort (map ( \l -> unionBy equalFst l defaults) tmp1)
-- SLUT PÅ KODSKELLET
profileDistance :: Profile -> Profile -> Double
profileDistance p0 p1 = res
						where
						carr = 	if isDNAP(p0) then nucleotides --Räknar med att p0 och p1 är av samma typ
								else aminoacids
						res = sum [sum[ abs ( (profileFrequency p0 j (carr !! i)) - (profileFrequency p1 j (carr !! i)))| j <- [0..(length (proMat p0) - 1)]     ] | i <- [0..(length carr - 1)]]


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


{-}
main s = do
	if null s
		then return ()
		else do
			putStrLn $ makeTree s
-}


main = interact makeTree

getValue :: MolSeq -> MolSeq -> [(String,String,Double)] -> Double
getValue a b m = res 
				where
				get3th (_,_,a) = a
				checkpair (t1,t2,t3) a b = (t1 == name a && t2 == name b) || (t1 == name b && t2 == name a)
				n = get3th([ t | t <- m, (checkpair t a b) ] !! 0)
				res = if (length [ t | t <- m, (checkpair t a b)]) == 0 then error (name b) else n

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