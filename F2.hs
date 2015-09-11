-- Av Felix Hedenström och Jonathan Rinnarv
module F2 where
data MolSeq = MolSeq String String Bool -- If it's DNA, the bool should be True
string2seq :: String -> String -> MolSeq
string2seq n s = if isACGT(s) then MolSeq n s True
		else MolSeq n s False

-- Check if string only contains ACGT
isACGT :: String -> Bool
isACGT [] = True -- Kanske bör ändras till isACGT (x:[]) = True
isACGT (a:s) = if (elem a "ACGT") then isACGT(s)
		else False  

seqName :: MolSeq -> String
seqName (MolSeq n _ _) = n

seqSequence :: MolSeq -> String
seqSequence (MolSeq _ s _) = s 

-- Checks if a MolSeq is of type DNA
isDNA :: MolSeq -> Bool
isDNA (MolSeq _ _ b) = b
seqLength :: MolSeq -> Int
seqLength (MolSeq _ s _) = length s 

seqDistance :: MolSeq -> MolSeq -> Double
seqDistance (MolSeq _ s0 b0) (MolSeq _ s1 b1) = if not (b0 == b1) then error "The MolSeq:s was not of the same types"
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

-- Profile
data Profile = Profile [[Double]] Bool Int String -- M, DNA eller inte, Hur många sekvenser den är byggd av, Namnet på profilen

--molseqs2profile :: String -> [MolSeq] -> Profile
--molseqs2profile n ma = Profile [[//TODO]] isDNA(ma !! 0) (length ma) n 
distanceMatrix a = []
profileFrequency a = []
profileDistTest a = []
profileDistance a = []

