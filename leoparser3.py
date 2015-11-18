#!/usr/bin/env python
# -*- coding: utf-8 -*-
#Author: Felix Hedenstrom och Jonathan Rinnarv


#<Uttryck> 	::= REP <Faktor> "<Uttryck>". | <Term> | REP <Faktor> <Term>
#<Term>		::=  <Styr> <Faktor> . | <StyrPenna>. | COLOR #<Faktor>. | .
#<Styr> 	::= FORW | BACK | LEFT | RIGHT
#<StyrPenna>::= DOWN | UP
#<Faktor> 	::= TAL



from sys import stdin
import re
import math

# This is how the parser describes the syntax tree
# 1: 	FORW
# 2: 	BACK
# 3: 	LEFT
# 4: 	RIGHT
# 5: 	DOWN
# 6: 	UP
# 7: 	COLOR
# 8: 	REP
# 9: 	QUOTE
# 10:   WHITESPACE
# 11: 	[NUMBER, VALUE]
# 12: 	HASH
# 13:	PERIOD
# 14: 	INVALID

FORW_N 			= 1
BACK_N 			= 2
LEFT_N 			= 3
RIGHT_N 		= 4
DOWN_N 			= 5
UP_N 			= 6
COLOR_N 		= 7
REP_N			= 8
QUOTE_N			= 9
WHITESPACE_N	= 10
NUMBER_N		= 11
HASH_N			= 12
PERIOD_N 		= 13
INVALID_N		= 14

FORW 			= "^\s*FORW\s*$"
BACK 			= "^\s*BACK\s*$"
LEFT 			= "^\s*LEFT\s*$"
RIGHT 			= "^\s*RIGHT\s*$" 
DOWN 			= "^\s*DOWN\s*$"
UP 				= "^\s*UP\s*$"
COLOR 			= "^\s*COLOR\s*$"
REP 			= "^\s*REP\s*$"
QUOTE 			= "^\s*\"\s*$" 
WHITESPACE 		= "^\s+$"
NUMBER 			= "^\s*\d+\s*$"
HASH 			= "\s*^#\s*$"  
PERIOD 			= "^\s*\.\s*$"
ALLOPTIONS 		= [FORW,BACK,LEFT,RIGHT,DOWN,UP,COLOR,REP,QUOTE,WHITESPACE,NUMBER,HASH,PERIOD]
#ANYVALID = WHITESPACE + "|" + NUMBER + "|" + HASHNUMBER + "|" + FORW + "|" + BACK + "|" + LEFT + "|" + RIGHT + "|" + DOWN + "|" + UP + "|" + COLOR + "|" + REPBEGIN + "|" + QUOTE + "|" + PERIOD



def main():
	pre_lex 	= stdin.read().upper()
	post_lex 	= lexer(pre_lex)
	if 14 in post_lex:
		error(pre_lex,post_lex.index(14))
		return
	post_parse 	= parse(post_lex,[],1)
	if not(isinstance(post_parse,list)):
		error(pre_lex,post_parse)
		return
	print post_lex
def lexer(s_input):
	s_input = re.sub("(\%.*)?\n",' ', s_input)
	temp = [i for i in re.split(r'(\s+|\.|\d+|\W+)', s_input) if i]
	tokens = []
	for token in temp:
		valid = False
		for i in range(0,13):
			if re.search(ALLOPTIONS[i],token):
				if i == 11 - 1:
					tokens.append([i + 1,int(re.findall("\d+",token)[0])])
				else:
					tokens.append(i + 1)
				valid = True
				break
		if not(valid):
			tokens.append(14)
	return tokens
def parse(l_input,syntaxtree,counter):
	if counter = len(l_input):
		return syntaxtree
	elif l_input[counter - 1] in [FORW_N, BACK_N, LEFT_N, RIGHT_N]:
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list):
			if l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parse(l_input,syntaxtree,counter + 3)
			elif l_input[counter + 2] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parse(l_input,syntaxtree,counter + 2)
	elif l_input[counter - 1] in [UP_N, DOWN_N]:
					
	elif l_input[counter - 1] in WHITESPACE_N:
		return parse(l_input,syntaxtree,counter + 1)
	return counter
#TODO
def error(pre_lex, n):
	lines = re.sub("(\%.*)",'', base_string).split("\n")
	startline = findStartLine(lines, n)
	for line in range(startline,len(lines)-1):
		if line == startline:
			if not(checkLine(lines[line - 1])) and not(checkLast(lines[line - 1])):
				print "Syntaxfel på rad " + str(lineN)
				return
		elif not(re.search("^(\%.*)?\s*$", line)):
			print "Syntaxfel på rad " + str(lineN)
			return
	print "Syntaxfel på rad " + str(startline)
	return

def checkLast(line):
	statements = line.split(".")
	s = statements[-1]
	if re.search("^\s*$",s):
		return True
	if re.search("^(\s*(FORW|BACK|LEFT|RIGHT|COLOR)\s*)$", s):
		return True
	return False

def checkLine(line):
	DIRECTION = "^(\s*(FORW|BACK|LEFT|RIGHT)\s+\d+\s*)$"
	UPDOWN = "^(\s*(DOWN|UP)\s*)$"
	COLOR = "^(\s*COLOR\s+\#[0-9A-F]{6}\s*)$"
	EMPTY = "^\s*$"
	COMBINED = DIRECTION + "|" + UPDOWN + "|" + COLOR + "|" + EMPTY	
	statements = line.split(".")
	del statements[-1]
	for statement in statements:
		if not(re.search(COMBINED, statement)):
			return False
	return True

def findStartLine(lines, n):
	tokens = 0
	lineN = 1
	for line in lines:
		templine = [i for i in re.split(r'(\s+|\.|\d+|\W+)', s_input) if i]
		tokens += len(templine)
		if tokens > n:
			return lineN
		lineN += 1
	print ("Custom error findStartLine")
	return -1

main()