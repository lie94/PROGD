-- Gjord utav Jonathan Rinnarv och Felix hjälpte till
module F1 where
import Data.Char
import Data.List
-- Vad ska de andra funktionernas typsignaturer vara?
fib :: Integer -> Integer
fib n = if n == 0 			-- If it's the zero:th number
	then 0
	else if n == 1 			-- If it's the first number
	then 1
	else fib (n-1) + fib (n-2) 	-- If it's any other number
-- Rövarspråket
rovarsprak :: [Char] -> [Char]
rovarsprak [] = [] 
rovarsprak (c:s) = 	if not (isVowel c) -- If it's not a vowel
				then c : 'o' : c : rovarsprak s
			else 	-- If it's a vowel
				c : rovarsprak s
-- isVowel checks if a character is a vowel
isVowel :: Char -> Bool
isVowel s = elem s "aeiouy"
-- karpsravor
karpsravor :: String -> String
karpsravor [] = [] 
karpsravor (c:s) = 	if check(c:(take 2 s))
				then c : karpsravor (drop 2 s) 
			else c : karpsravor s
-- check
-- If s and the next two characters are in the form consonant-o-consonant,
-- return true, else return false
check s = not (isVowel (head s)) && head s == last s && length s == 3 && s !! 1 == 'o' 

-- Medellängd
-- Counts through all chars in the strings. First it counts the numbers of letters, then it counts the number of words. It returns the number of letters divided by the number of words.
medellangd :: String -> Double
medellangd s = 	if not (isAlpha(s !! 0))
				then search s 0 0 True
				else search s 0 0 False	
			where
			search (c:s) wordCount letterCount newWord -- newWord is False if the last char was an alpha
				| isAlpha(c)	= search s wordCount (letterCount + 1) False
				| otherwise 	= if newWord then search s wordCount letterCount True else search s (wordCount + 1) letterCount True
			search [] wordCount letterCount newWord -- If the list is empty, return the ratio letters / words
				| newWord 	= letterCount / (wordCount)
				| otherwise 	= letterCount / (wordCount + 1)

{-medellangd s = 	if not (isAlpha(s !! 0)) -- If the string starts with a non alpha 
		then fromIntegral (length ([0 | x <- s, isAlpha(x)]) ) / fromIntegral ((length [0 | i <- [1..((length s) - 1)], isAlpha(s !! i) && (not (isAlpha(s !! (i - 1))))])) 		
		-- if the string starts with an awhelpha, add a word at the end
		else fromIntegral (length ([0 | x <- s, isAlpha(x)]) ) / fromIntegral ((length [0 | i <- [1..((length s) - 1)], isAlpha(s !! i) && (not (isAlpha(s !! (i - 1))))] + 1))-}
-- Listskyffling
--skyffla :: [] -> []
skyffla l = 	if length l <= 1 -- If the list has length 1, return only the list without sorting
				then l
				-- Make a list containing only the even indexed elements and join it with the recusive call of the function
				else [l !! i | i <- [0..(length l)- 1], even i] ++ skyffla [l !! i | i <- [0..(length l) - 1], odd i]