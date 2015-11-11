#Author: Felix Hedenstrom och Jonathan Rinnarv
# -*- coding: utf-8 -*-
from sys import stdin
import re

def main():
	lineNr = 1
	test = stdin.read()
	test = re.sub("\n",'', test)
	test = repr(test)
	print test

	for line in stdin:
		print lineNr
		n = correctSyntax(line)
		if n == 0:
			print "Syntaxfel på rad " + str(lineNr)
			return;
		lineNr += 1
	stdin.seek(0)		
	x = 0
	y = 0
	linecounter = 1
	print "KLAR"
	#while True:
	#	pass
#0 KAN ALDRIG FUNGERA
#1 FUNGERAR
#2 FUNGERAR OM DET FÖLJS AV COLOR
#3 FUNGERAR OM DET FÖLJS AV HELTAL
#4 FUNGERAR OM DET FÖLJS AV PUNKT
# OM sista elementet inte är blankt, dvs linen slutar inte på . 
def correctSyntax(inp_sting):
	#if (re.search("\%.*",inp_sting):
	#	return 1
	s = inp_sting.upper()
	DIRECTION = "^(\s*(FORW|BACK|LEFT|RIGHT)\s+\d+\s*)$"
	UPDOWN = "^((DOWN|UP)\s*)$"
	COLOR = "^(\s*COLOR\s+\#[0-9A-F]{6}\s*)$"
	EMPTY = "^\s*$"
	COMBINED = DIRECTION + "|" + UPDOWN + "|" + COLOR + "|" + EMPTY	
	for substring in s.split("."):
		if not(re.search(COMBINED, substring)):
			return 0
	return 1
main()