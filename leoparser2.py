#Author: Felix Hedenstrom och Jonathan Rinnarv
# -*- coding: utf-8 -*-

#<Uttryck> 	::= REP <Faktor> "<Uttryck>". | <Term> | REP <Faktor> "<Term>"
#<Term>		::=  <Styr> <Faktor> . | <StyrPenna>. | COLOR #<Faktor>. | .
#<Styr> 	::= FORW | BACK | LEFT | RIGHT
#<StyrPenna>::= DOWN | UP
#<Faktor> 	::= TAL

# This is how the parser describes the syntax tree
# 1: FORW
# 2: BACK
# 3: LEFT
# 4: RIGHT
# 5: DOWN
# 6: UP
# 7: COLOR

# OM PROGRAMMET ÄR LÅNGSAMT, TESTA ATT BYTA UT SAMMA INSTURKTION FLERA GÅNGER MOT DESSA
# 8: REP
# 9: GOTOPREVIOUS REP



from sys import stdin
import re

DIRECTION = "^(\s*(FORW|BACK|LEFT|RIGHT)\s+\d+\s*)$"
UPDOWN = "^((DOWN|UP)\s*)$"
COLOR = "^(\s*COLOR\s+\#[0-9A-F]{6}\s*)$"
EMPTY = "^\s*$"
COMBINED = DIRECTION + "|" + UPDOWN + "|" + COLOR + "|" + EMPTY	
base_string = ""

def main():
	global base_string
	base_string = stdin.read()
	base_string = base_string.upper()
	splitpunctuation_string = re.sub("(\%.*)?\n",'', base_string).split(".")
	syntaxtree =	recursiveCheck(splitpunctuation_string,[],1)
	if len(syntaxtree) == 0:
		return
	#EVERYTHING IS FINE, CALCULATE PATH
	printPath()
def findLine(n, punctuationsPerLine):
	total_punctuation = 0
	for i in range(0, len(punctuationsPerLine)):
		if total_punctuation >= n:
			return i
		total_punctuation += punctuationsPerLine[i]
	if total_punctuation >= n:
		return len(punctuationsPerLine)
	return "ERROR"
# TODO
def printPath():
	print "KLAR"
# TODO
def recursiveCheck(split_string, syntaxtree, counter):
	if len(split_string) == counter:
		return [0]
	elif re.search(COMBINED,split_string[counter - 1]):
		return recursiveCheck(split_string,syntaxtree,counter + 1)#.append([1,0]).append(syntaxtree)
		
	elif re.search("REP\s+\d+\s+\"", split_string[counter - 1]):
		temp = re.sub("^(REP\s+\d+\s+\")",'',split_string[counter - 1])
		temp = [temp, " "]
		part_tree = recursiveCheck(temp,[],1)
		return recursiveCheck(split_string,syntaxtree,counter + 1)


	punctuationsPerLine = getPunctuationsPerline()
	print "Syntaxfel på rad " + str(findLine(counter, punctuationsPerLine))
	return []

def getPunctuationsPerline():
	s = base_string.split('\n')
	returnList = []
	for line in s:
		#temp_line = re.sub('\%.*','',line)
		returnList.append(len(line.split('.')) - 1)
	return returnList
main()