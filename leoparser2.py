#Author: Felix Hedenstrom och Jonathan Rinnarv


#<Uttryck> 	::= REP <Faktor> "<Uttryck>". | <Term> | REP <Faktor> <Term>
#<Term>		::=  <Styr> <Faktor> . | <StyrPenna>. | COLOR #<Faktor>. | .
#<Styr> 	::= FORW | BACK | LEFT | RIGHT
#<StyrPenna>::= DOWN | UP
#<Faktor> 	::= TAL



# OM PROGRAMMET ÄR LÅNGSAMT, TESTA ATT BYTA UT SAMMA INSTURKTION FLERA GÅNGER MOT DESSA
# 8: REP
# 9: GOTOPREVIOUS REP



from sys import stdin
import re
import math

DIRECTION = "^(\s*(FORW|BACK|LEFT|RIGHT)\s+\d+\s*)$"
UPDOWN = "^(\s*(DOWN|UP)\s*)$"
COLOR = "^(\s*COLOR\s+\#[0-9A-F]{6}\s*)$"
EMPTY = "^\s*$"
COMBINED = DIRECTION + "|" + UPDOWN + "|" + COLOR + "|" + EMPTY	
base_string = "" #Behöver inte vara global

def main():
	global base_string
	base_string = stdin.read()
	base_string = base_string.upper()
	splitpunctuation_string = re.sub("(\%.*)?\n",' ', base_string).split(".")
	#print(splitpunctuation_string)
	syntaxtree = recursiveCheck(splitpunctuation_string,[],1)
	if not(isinstance(syntaxtree[0],list)):
		printError(syntaxtree[0])
		return
	#EVERYTHING IS FINE, CALCULATE PATH
	printPath(syntaxtree)

def printError(statement):
	lines = re.sub("(\%.*)",'', base_string).split("\n")
	startLine = findStartLine(statement) #Skicka med lines
	#print (statement)
	#print (startLine)
	lineNumber = 1
	for line in lines: #Här går att optimera
		if lineNumber < startLine:
			lineNumber += 1
			continue
		if lineNumber == startLine:
			if not(checkLine(line)) or not(checkLast(line)):
				print ("Syntaxfel på rad " + str(lineNumber))
				return
			else:
				lineNumber += 1
				continue
		if not(re.search("^(\%.*)?\s*$", line)):
			print ("Syntaxfel på rad " + str(lineNumber))
			return
		lineNumber += 1
	print ("Syntaxfel på rad " + str(startLine))
	return

def checkLast(line):
	statements = line.split(".")
	s = statements[-1]
	if re.search(EMPTY,s):
		return True
	if re.search("^(\s*(FORW|BACK|LEFT|RIGHT|COLOR)\s*)$", s):
		return True
	return False


def checkLine(line):
	statements = line.split(".")
	del statements[-1]
	for statement in statements:
		if not(re.search(COMBINED, statement)):
			return False
	return True
	
def findStartLine(n):
	lines = re.sub("(\%.*)",'', base_string).split("\n")
	lineN = 1
	tokens = 0
	for line in lines:
		#print (len(line.split(".")) - 1 )
		tempLine = line.split(".")
		if checkLast(line):
			tokens += len(tempLine) - 1
		else:
			tokens += len(tempLine)
		if tokens >= n:
			return lineN
		lineN += 1
	return -1



"""def findLine(n, statmentsPerLine):
	total_punctuation = 0
	for i in range(0, len(statmentsPerLine)):
		if total_punctuation >= n:
			return i
		total_punctuation += statmentsPerLine[i]
	if total_punctuation >= n:
		return len(statmentsPerLine)
	return "ERROR"""
# TODO
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

	#for i in syntaxtree:
	#	print (i)
# TODO: Måste ta hand om errors i loopar
def recursiveCheck(split_string, syntaxtree, counter):
	if len(split_string) + 1 == counter:
		return syntaxtree
	elif re.search(COMBINED,split_string[counter - 1]):
		if not(re.search(EMPTY,split_string[counter-1])):
			syntaxtree.append(getCode(split_string[counter-1]))
		return recursiveCheck(split_string,syntaxtree,counter + 1)
		
	elif re.search("REP\s+\d+\s+\"", split_string[counter - 1]):
		d = int(re.findall("\d+",split_string[counter - 1])[0])
		split_string[counter - 1] = re.sub("^\s*(REP\s+\d+\s+\")",'',split_string[counter - 1])
		loopEnd = getEndLoop(split_string, counter, 0)
		if loopEnd == 0:
			return [counter]
		if re.search("\"\s*$",split_string[loopEnd - 1]):
			split_string[loopEnd - 1] = re.sub("\"\s*$",'',split_string[loopEnd - 1])
		else:
			split_string[loopEnd - 1] = re.sub("^\s*\"",'',split_string[loopEnd - 1])
		
		newList = split_string[counter-1:loopEnd-1] #Jonathan vet precis varför detta skall vara "-1"
		part_tree = recursiveCheck(newList, [], 1)
		if not(isinstance(part_tree[0],list)):
			counter += part_tree[0] - 1
		else:
			for i in range(0,d):
				syntaxtree += (part_tree)
			return recursiveCheck(split_string,syntaxtree,loopEnd) #Felix vet precis varför det skall inte vara "+1"

	elif re.search("REP\s+\d+\s+", split_string[counter - 1]):
		d = int(re.findall("\d+",split_string[counter - 1])[0])
		split_string[counter - 1] = re.sub("^\s*(REP\s+\d+\s+)",'',split_string[counter - 1])
		part_tree = recursiveCheck([split_string[counter - 1]], [], 1)
		if not(isinstance(part_tree[0],list)):
			counter += part_tree[0] - 1
		else:
			for i in range(0,d):
				syntaxtree += (part_tree)
			return recursiveCheck(split_string,syntaxtree,counter + 1)

	return [counter]

def getEndLoop(split_string, counter, depth):
	if re.search("^\s*REP\s+\d+\s+\"", split_string[counter - 1]):
		return getEndLoop(split_string, counter + 1, depth + 1)
	if re.search("\"", split_string[counter - 1]):
		if depth == 0:
			return counter
		return getEndLoop(split_string, counter, depth - 1)
	if len(split_string) == counter:
		return 0
	return getEndLoop(split_string, counter + 1, depth)


"""def getStatmentsPerLine():
	s = base_string.split('\n')
	returnList = []
	for line in s:
		temp_line = re.sub('\%.*','',line)
		ss = temp_line.split('.')
			returnList.append(len(ss) - 1)
		else:
			returnList.append(len(ss))
	return returnList"""

# This is how the parser describes the syntax tree
# 1: FORW
# 2: BACK
# 3: LEFT
# 4: RIGHT
# 5: DOWN
# 6: UP
# 7: COLOR

def getCode(exp):
	if re.search("DOWN",exp):
		return [5,0]
	elif re.search("UP",exp):
		return [6,0]
	n = int(re.findall("\d+",exp)[0])
	if re.search("FORW",exp):
		return [1,n]
	elif re.search("BACK",exp):
		return [2,n]
	elif re.search("LEFT",exp):
		return [3,n]
	elif re.search("RIGHT",exp):
		return [4,n]
	if re.search("COLOR",exp):
		exp = re.sub("COLOR",'',exp)
		n = re.findall("#[A-F\d]+",exp)[0]
		return [7,n]
	print ("GetCode ERROR " + exp)
	return 0

main()