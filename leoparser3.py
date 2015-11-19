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
# 15: 	REP ONE THING

SPLITPATTERN = r'(\#[\dA-F]{6}|\"|\s+|\.|\d+|\W+)'

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
REPONE_N		= 15

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
HASH 			= "\s*^#[\dA-F]{6}\s*$"  
PERIOD 			= "^\s*\.\s*$"
ALLOPTIONS 		= [FORW,BACK,LEFT,RIGHT,DOWN,UP,COLOR,REP,QUOTE,WHITESPACE,NUMBER,HASH,PERIOD]
#ANYVALID = WHITESPACE + "|" + NUMBER + "|" + HASHNUMBER + "|" + FORW + "|" + BACK + "|" + LEFT + "|" + RIGHT + "|" + DOWN + "|" + UP + "|" + COLOR + "|" + REPBEGIN + "|" + QUOTE + "|" + PERIOD

def main():
	pre_lex 	= stdin.read().upper()
	pre_lex		= re.sub("\t",'',pre_lex)
	#print "main:pre_lex\t:" + str(pre_lex)
	post_lex 	= lexer(pre_lex)
	#print "main:post_lex\t: " + str(post_lex)
	syntaxtree	= parse(post_lex,[],1,0,len(post_lex))
	if not(isinstance(syntaxtree,list)):
		print "error token: " + str(syntaxtree)
		error(pre_lex,syntaxtree)
		return
	#print "main:syntaxtree\t: " + str(syntaxtree)
	printPath(syntaxtree)
def lexer(s_input):
	s_input = re.sub("\n", ' ' , re.sub("(\%.*)",' ', s_input))
	#print "lexer:s_input: " + str(s_input)
	temp = [i for i in re.split(SPLITPATTERN, s_input) if i]
	#print "lexer:temp\t:" + str(temp)
	tokens = []
	for token in temp:
		valid = False
		for i in range(0,13):
			if re.search(ALLOPTIONS[i],token):
				if i == NUMBER_N - 1:
					tokens.append([i + 1,int(re.findall("\d+",token)[0])])
				elif i == HASH_N - 1:
					tokens.append([i + 1, token])
				else:
					tokens.append(i + 1)
				valid = True
				break
		if not(valid):
			tokens.append(14)
	return tokens
def parse(l_input,syntaxtree,counter,repCounter,l_input_length):
	if counter == l_input_length + 1:
		if repCounter != 0:
			counter -= 1
		else:
			return syntaxtree
	#else:
	#	print "l_input[" + str(counter - 1) + "]: " + str(l_input[counter - 1])
	elif l_input[counter - 1] in [FORW_N, BACK_N, LEFT_N, RIGHT_N] and counter + 2 < l_input_length: 							#RIGHT LEFT BACK FORW
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list) and isinstance(l_input[counter + 1][1],int):
			if l_input[counter + 2] == WHITESPACE_N and counter + 3 < l_input_length and l_input[counter + 3] == PERIOD_N:  #Om det är space efter siffran följt av punkt
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parse(l_input,syntaxtree,counter + 5, repCounter, l_input_length)
			elif l_input[counter + 2] == PERIOD_N:																			#Om siffran är direct följt av punkt
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parse(l_input,syntaxtree,counter + 4, repCounter, l_input_length)


	elif l_input[counter - 1] in [UP_N, DOWN_N] and counter < l_input_length:												#DOWN UP
		if l_input[counter] == WHITESPACE_N and counter + 1 < l_input_length and l_input[counter + 1] == PERIOD_N:			#Om det är space innan punkten
			syntaxtree.append([l_input[counter - 1], 0]) # 0 Eftersom vi inte har någon styrsiffra som i de andra fallen
			return parse(l_input,syntaxtree,counter + 3, repCounter, l_input_length)
		elif l_input[counter] == PERIOD_N:																					#Om det inte är space innan punkten
			syntaxtree.append([l_input[counter - 1], 0])
			return parse(l_input,syntaxtree,counter + 2, repCounter, l_input_length)

	elif l_input[counter - 1] == WHITESPACE_N:													#WHITESPACE
		return parse(l_input,syntaxtree,counter + 1, repCounter, l_input_length)
	

	elif l_input[counter - 1] == REP_N and counter + 2 < l_input_length:						#REPSTART
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list) and isinstance(l_input[counter + 1][1],int):
			if counter + 3 < l_input_length and l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == QUOTE_N:		#Om det är ett quote efter
				print counter
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parse(l_input, syntaxtree, counter + 5, repCounter + 1, l_input_length)
				#TODO
			elif l_input[counter + 2] == WHITESPACE_N:																												#Om det inte är ett quote efter
				syntaxtree.append([REPONE_N,l_input[counter + 1][1]])
				return parse(l_input, syntaxtree, counter + 3, repCounter, l_input_length) 
	elif l_input[counter - 1] == QUOTE_N and repCounter != 0:														#REPSLUT
		syntaxtree.append([l_input[counter - 1], 0])
		return parse(l_input, syntaxtree, counter + 1, repCounter - 1, l_input_length)
	elif counter + 2 < l_input_length and l_input[counter - 1] == COLOR_N:														#COLOR
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list) and isinstance(l_input[counter + 1][1], basestring):
			if l_input[counter + 2] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parse(l_input, syntaxtree, counter + 4, repCounter, l_input_length)
			elif counter + 3 < l_input_length and l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parse(l_input, syntaxtree, counter + 5, repCounter, l_input_length)
	return counter


#TODO
# ERRORET SER UT ATT VARA OFF BY ONE
def error(pre_lex, n):
	lines = re.sub("(\%.*)",'', pre_lex).split("\n")
	startline = findStartLine(lines, n)
	print "error:startline\t: " + str(startline)
	for line in range(startline,len(lines)-1):
		if line == startline:
			if not(checkLine(lines[line - 1])) or not(checkLast(lines[line - 1])):
				print "Syntaxfel på rad " + str(line)
				return
		elif not(re.search("^(\%.*)?\s*$", lines[line - 1])):
			print "Syntaxfel på rad " + str(line)
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
		templine = [i for i in re.split(SPLITPATTERN, line) if i]
		#print "templine: " + str(templine)
		tokens += (len(templine) + 1)
		if tokens >= n:
			return lineN
		lineN += 1
	print ("Custom error findStartLine")
	return -1
def printPath(syntaxtree):
	x = 0
	y = 0
	color = "#0000FF"
	angle = 0
	draw = False
	moved = False
	newX = 0
	newY = 0

	for s in syntaxtree:
		if s[0] == 1:
			newX = x+s[1]*math.cos(math.pi*angle/180)
			newY = y+s[1]*math.sin(math.pi*angle/180)
			moved = True
		elif s[0] == 2:
			newX = x-s[1]*math.cos(math.pi*angle/180)
			newY = y-s[1]*math.sin(math.pi*angle/180)
			moved = True
		elif s[0] == 3:
			angle = (angle + s[1]) % 360
		elif s[0] == 4:
			angle = (angle - s[1]) % 360
		elif s[0] == 5:
			draw = True
		elif s[0] == 6:
			draw = False
		elif s[0] == 7:
			color = s[1]
		if draw and moved:
			print (color + " %.4f %.4f %.4f %.4f" % (x,y,newX,newY))
		x = newX
		y = newY
		moved = False
main()