-- Av Felix Hedenström och Jonathan Rinnarv
module F2 where
import Data.List
data Evol = MolSeq | Profile
distance :: Evol -> Evol -> Double
distance (s0 :: MolSeq) (s1 :: MolSeq)  = seqDistance s0 s1 
--distance p0 :: Profile (p1 :: Profile) = profileDistance p0 p1

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
isDNA :: MolSeq -> Bool
isDNA (Molseqconst _ _ b) = b

isDNAP :: Profile -> Bool -- isDNA for Profileconsts
isDNAP (Profileconst _ b _ _) = b

seqLength :: MolSeq -> Int
seqLength (Molseqconst _ s _) = length s 

seqDistance :: MolSeq -> MolSeq -> Double
seqDistance (Molseqconst _ s0 b0) (Molseqconst _ s1 b1) = if not (b0 == b1) then error "The Molseqconst:s was not of the same types"
		else formulaCheck b0 ((seqDistanceHelp s0 s1 0 ) / fromIntegral(length s0))

seqDistanceHelp :: String -> String -> Double -> Double
seqDistanceHelp [] [] notMatches = notMatches
seqDistanceHelp (h0:s0) (h1:s1) notMatches = if not (h0 == h1) then seqDistanceHelp s0 s1 (notMatches + 1)
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
profileFrequency p i c = fromIntegral((search((proMat p) !! i) c))/(fromIntegral(proLen p))
	where
		search (h:t) c
			|	fst(h) == c = snd(h)
			|	otherwise = search t c
		search [] _ = 0


molseq2profile :: String -> [MolSeq] -> Profile
molseq2profile n ma = (Profileconst (makeProfileMatrix ma) (isDNA(ma !! 0)) (length ma) n)

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
	tmp1 = map ( map ( \x -> ((head x), (length x))) . group . sort) (transpose strs)
	-- map f(g(x)) m
	equalFst a b = (fst a) == (fst b)
	res = map sort (map ( \l -> unionBy equalFst l defaults) tmp1)
-- SLUT PÅ KODSKELLET
profileDistance :: Profile -> Profile -> Double
profileDistance p0 p1 = res
						where
						carr = 	if isDNAP(p0) then nucleotides --Räknar med att p0 och p1 är av samma typ
								else aminoacids
						res = sum [sum[ abs ( (profileFrequency p0 j (carr !! i)) - (profileFrequency p1 j (carr !! i)))| j <- [0..(length (proMat p0) - 1)]     ] | i <- [0..(length carr - 1)]]


distanceMatrix a = []
