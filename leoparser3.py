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
HASH 			= "\s*^#\d{6}\s*$"  
PERIOD 			= "^\s*\.\s*$"
ALLOPTIONS 		= [FORW,BACK,LEFT,RIGHT,DOWN,UP,COLOR,REP,QUOTE,WHITESPACE,NUMBER,HASH,PERIOD]
#ANYVALID = WHITESPACE + "|" + NUMBER + "|" + HASHNUMBER + "|" + FORW + "|" + BACK + "|" + LEFT + "|" + RIGHT + "|" + DOWN + "|" + UP + "|" + COLOR + "|" + REPBEGIN + "|" + QUOTE + "|" + PERIOD

def main():
	pre_lex 	= stdin.read().upper()
	pre_lex		= re.sub("\t",'',pre_lex)
	#print pre_lex
	post_lex 	= lexer(pre_lex)
	print "post_text: " + str(post_lex)
	post_parse 	= parse(post_lex,[],1,0)
	if not(isinstance(post_parse,list)):
		error(pre_lex,post_parse)
		return
	print "post_parse:" + str(post_parse)
def lexer(s_input):
	s_input = re.sub("(\%.*)?\n",' ', s_input)
	temp = [i for i in re.split(r'(\#\d+|\s+|\.|\d+|\W+)', s_input) if i]
	print temp
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
def parse(l_input,syntaxtree,counter,repCounter):
	print "l_input[" + str(counter - 1) + "]: " + str(l_input[counter - 1])
	if counter == len(l_input):
		return syntaxtree
	elif l_input[counter - 1] in [FORW_N, BACK_N, LEFT_N, RIGHT_N]: 							#RIGHT LEFT BACK FORW
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list):
			if l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parse(l_input,syntaxtree,counter + 5, repCounter)
			elif l_input[counter + 2] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parse(l_input,syntaxtree,counter + 4, repCounter)


	elif l_input[counter - 1] in [UP_N, DOWN_N]:												#DOWN UP
		if l_input[counter] == WHITESPACE_N and l_input[counter + 1] == PERIOD_N:
			syntaxtree.append([l_input[counter - 1], 0]) # 0 Eftersom vi inte har någon styrsiffra som i de andra fallen
			return parse(l_input,syntaxtree,counter + 3, repCounter)
		elif l_input[counter] == PERIOD_N:
			syntaxtree.append([l_input[counter - 1], 0])
			return parse(l_input,syntaxtree,counter + 2, repCounter)

	elif l_input[counter - 1] == WHITESPACE_N:													#WHITESPACE
		return parse(l_input,syntaxtree,counter + 1, repCounter)
	

	elif l_input[counter - 1] == REP_N:															#REPSTART
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list):
			if l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == QUOTE_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parse(l_input, syntaxtree, counter + 5, repCounter + 1)
				#TODO
			else:
				pass
				#TODO
				#OM DET ÄR EN UTAN CITATTECKEN
	elif l_input[counter - 1] == QUOTE_N:														#REPSLUT
		syntaxtree.append([l_input[counter - 1], 0])
		return parse(l_input, syntaxtree, counter + 1, repCounter - 1)
	elif l_input[counter - 1] == COLOR_N:														#COLOR
		if l_input[counter] == WHITESPACE_N and l_input[counter + 1] == HASH_N:
			if l_input[counter + 2] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1]])
				return parse(l_input, syntaxtree, counter + 4, repCounter)
			elif l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1]])
				return parse(l_input, syntaxtree, counter + 5, repCounter)
	return counter
#TODO
def error(pre_lex, n):
	print "Syntaxfel på rad " + str(n)
	return
main()