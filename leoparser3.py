#!/usr/bin/env python
# -*- coding: utf-8 -*-
#Author: Felix Hedenstrom och Jonathan Rinnarv


#<Uttryck> 	::= REP <Faktor> "<Uttryck>". | <Term> | REP <Faktor> <Term>
#<Term>		::=  <Styr> <Faktor> . | <StyrPenna>. | COLOR #<Faktor>.
#<Styr> 	::= FORW | BACK | LEFT | RIGHT
#<StyrPenna>::= DOWN | UP
#<Faktor> 	::= TAL



#from sys import stdin
import sys
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
NUMBER 			= "^\s*[1-9]\d*\s*$"
HASH 			= "\s*^#[\dA-F]{6}\s*$"  
PERIOD 			= "^\s*\.\s*$"
ALLOPTIONS 		= [FORW,BACK,LEFT,RIGHT,DOWN,UP,COLOR,REP,QUOTE,WHITESPACE,NUMBER,HASH,PERIOD]
#ANYVALID = WHITESPACE + "|" + NUMBER + "|" + HASHNUMBER + "|" + FORW + "|" + BACK + "|" + LEFT + "|" + RIGHT + "|" + DOWN + "|" + UP + "|" + COLOR + "|" + REPBEGIN + "|" + QUOTE + "|" + PERIOD

def main():
	sys.setrecursionlimit(9000)
	pre_lex 	= sys.stdin.read().upper()
	pre_lex		= re.sub("\t",'',pre_lex)
	#print "main:pre_lex\t:" + str(pre_lex)
	post_lex 	= lexer(pre_lex)
	#printDebug(post_lex)
	#print "main:post_lex\t: " + str(post_lex)
	part1	= parsepart1(post_lex,[],1,0,len(post_lex))
	#print "main:part1\t: " + str(part1)
	if not(isinstance(part1,list)):
		#print "error token\t: " + str(part1)
		error(pre_lex,part1)
	else:
		syntaxtree = parsepart2(part1,[],0)
		#print "main:syntaxtree\t: " + str(syntaxtree)
		#print len(syntaxtree)
		printPath(syntaxtree)
	#print "main:syntaxtree\t: " + str(syntaxtree)

def printDebug(post_lex):
	for i in range(len(post_lex)):
		print "printDebug:post_lex nr." + str(i + 1) + "\t: " + str(post_lex[i])


def parsepart2(inst_list, new_list, index):
	if(index == len(inst_list)):
		return new_list
	#return inst_list
	if(inst_list[index][0] == REPONE_N):
		if index == len(inst_list) - 1:
			return new_list
		temp = [inst_list[index + 1],inst_list[index][1]]
		new_list.append(temp)
		return parsepart2(inst_list,new_list,  index + 2)
	elif inst_list[index][0] == REP_N:
		if index == len(inst_list) - 1:
			return new_list
		endrep = findEnd(inst_list, index + 1, 0)
		#DETTA ÄR NOLLINDEXERAT
		#print "parsepart2:endrep\t: " + str(endrep)
		if not(endrep == index + 1):
			subset = inst_list[(index + 1):endrep]
			#print "parsepart2:subset\t:" + str(subset)
			temp = parsepart2(subset,[],0)
			temp.append(inst_list[index][1])
			#temp.instert(0,inst_list[index][1])
			new_list.append(temp)
		else:		#NOP
			new_list.append([LEFT_N,0])
		return parsepart2(inst_list, new_list, endrep + 1)

		#GÖR JOBBIGT SKIT
	else:
		new_list.append(inst_list[index])
		return parsepart2(inst_list, new_list	,	index + 1)

def findEnd(inst_list, index, leftRepCounter):
	#print inst_list[index]
	if inst_list[index][0] == QUOTE_N:
		if leftRepCounter == 0:
			return index
		else:
			leftRepCounter -= 1
	elif inst_list[index][0] == REP_N:
		leftRepCounter += 1
	return findEnd(inst_list, index + 1, leftRepCounter)

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
	if tokens[0] == WHITESPACE_N:
		del tokens[0]
	return tokens

def parsepart1(l_input,syntaxtree,counter,repCounter,l_input_length):
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
				return parsepart1(l_input,syntaxtree,counter + 5, repCounter, l_input_length)
			elif l_input[counter + 2] == PERIOD_N:																			#Om siffran är direct följt av punkt
				syntaxtree.append([l_input[counter - 1],l_input[counter + 1][1]])
				return parsepart1(l_input,syntaxtree,counter + 4, repCounter, l_input_length)


	elif l_input[counter - 1] in [UP_N, DOWN_N] and counter < l_input_length:												#DOWN UP
		if l_input[counter] == WHITESPACE_N and counter + 1 < l_input_length and l_input[counter + 1] == PERIOD_N:			#Om det är space innan punkten
			syntaxtree.append([l_input[counter - 1], 0]) # 0 Eftersom vi inte har någon styrsiffra som i de andra fallen
			return parsepart1(l_input,syntaxtree,counter + 3, repCounter, l_input_length)
		elif l_input[counter] == PERIOD_N:																					#Om det inte är space innan punkten
			syntaxtree.append([l_input[counter - 1], 0])
			return parsepart1(l_input,syntaxtree,counter + 2, repCounter, l_input_length)

	elif l_input[counter - 1] == WHITESPACE_N:													#WHITESPACE
		return parsepart1(l_input,syntaxtree,counter + 1, repCounter, l_input_length)
	

	elif l_input[counter - 1] == REP_N and counter + 2 < l_input_length:						#REPSTART
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list) and isinstance(l_input[counter + 1][1],int):
			if counter + 3 < l_input_length and l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == QUOTE_N:		#Om det är ett quote efter
				#print counter
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parsepart1(l_input, syntaxtree, counter + 5, repCounter + 1, l_input_length)
			elif l_input[counter + 2] == WHITESPACE_N:																												#Om det inte är ett quote efter
				syntaxtree.append([REPONE_N,l_input[counter + 1][1]])
				return parsepart1(l_input, syntaxtree, counter + 3, repCounter, l_input_length) 
	elif l_input[counter - 1] == QUOTE_N and repCounter != 0:														#REPSLUT
		syntaxtree.append([l_input[counter - 1], 0])
		return parsepart1(l_input, syntaxtree, counter + 1, repCounter - 1, l_input_length)
	elif counter + 2 < l_input_length and l_input[counter - 1] == COLOR_N:														#COLOR
		if l_input[counter] == WHITESPACE_N and isinstance(l_input[counter + 1],list) and isinstance(l_input[counter + 1][1], basestring):
			if l_input[counter + 2] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parsepart1(l_input, syntaxtree, counter + 4, repCounter, l_input_length)
			elif counter + 3 < l_input_length and l_input[counter + 2] == WHITESPACE_N and l_input[counter + 3] == PERIOD_N:
				syntaxtree.append([l_input[counter - 1], l_input[counter + 1][1]])
				return parsepart1(l_input, syntaxtree, counter + 5, repCounter, l_input_length)
	return counter


#TODO
# ERRORET SER UT ATT VARA OFF BY ONE
def error(pre_lex, n):
	lines = re.sub("(\%.*)",'', pre_lex).split("\n")
	#print "error:n\t: " + str(n)
	startline = findStartLine(lines, n)
	#print "error:startline\t: " + str(startline)
	for line in range(startline,len(lines) + 1):
		if line == startline:
			if not(checkLine(lines[line - 1])) or not(checkLast(lines[line - 1])):
				print "Syntaxfel på rad " + str(line)
				return
		elif not(re.search("^\s*$", lines[line - 1])):
			print "Syntaxfel på rad " + str(line)
			return
	print "Syntaxfel på rad " + str(startline)

def checkLast(line):
	if re.search("^\.\s*",line):
		return False
	statements = line.split(".")
	s = statements[-1]
	#if re.search("^\s*(\"+\s*)*$",s):
	if(re.search("^\s*$",s)):
		return True
	if re.search("^(\s*(FORW|BACK|LEFT|RIGHT|COLOR)(\s+\d*)?\s*)$", s):
		return True
	return False

def checkLine(line):
	if re.search("\.\s*\.",line):
		return False
	DIRECTION = "^(\s*(FORW|BACK|LEFT|RIGHT)\s+\d+\s*)$"
	UPDOWN = "^(\s*(DOWN|UP)\s*)$"
	COLOR = "^(\s*COLOR\s+\#[0-9A-F]{6}\s*)$"
	EMPTY = "^\s*$"
	COMBINED = DIRECTION + "|" + UPDOWN + "|" + COLOR + "|" + EMPTY	
	statements = line.split(".")
	#print "checkLast:statements\t: " + str(statements)
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
		if len(templine) > 0 and not(re.search("^\s+$",templine[-1])):
			templine.append(" ")
			#print templine
		if len(templine) > 0 and re.search("^\s+$",templine[0]):
			del templine[0]

		#print "findStartLine:templine\t: " + str(templine)
		#print "findStartLine:len(templine)\t: " + str(len(templine))
		tokens += (len(templine))  #KANSKE + 1
		if tokens >= n:
			return lineN
		lineN += 1
	#print ("Custom error findStartLine")
	return -1



def printPath(syntaxtree):
	x = 0
	y = 0
	color = "#0000FF"
	angle = 0
	draw = False
	printPathinternal(syntaxtree,[x,y,color,angle,draw])

def printPathinternal(syntaxtree,data):
	moved = False
	newX = 0
	newY = 0
	#print "printPathinternal:syntaxtree\t: " + str(syntaxtree)
	for s in syntaxtree:
		#print str(s)
		#print data
		if isinstance(s[0],list):
			for i in range(s[-1]):
				data = printPathinternal(s[0:len(s)-1], data)
		elif s[0] == 1:
			newX = data[0]+s[1]*math.cos(math.pi*data[3]/180)
			newY = data[1]+s[1]*math.sin(math.pi*data[3]/180)
			moved = True
		elif s[0] == 2:
			newX = data[0]-s[1]*math.cos(math.pi*data[3]/180)
			newY = data[1]-s[1]*math.sin(math.pi*data[3]/180)
			moved = True
		elif s[0] == 3:
			data[3] = (data[3] + s[1]) % 360
		elif s[0] == 4:
			data[3] = (data[3] - s[1]) % 360
		elif s[0] == 5:
			data[4] = True
		elif s[0] == 6:
			data[4] = False
		elif s[0] == 7:
			data[2] = s[1]

		if moved:
			if data[4]:
				print (data[2] + " %.4f %.4f %.4f %.4f" % (data[0],data[1],newX,newY))
			data[0] = newX
			data[1] = newY
		moved = False
	return data
main()