% Gjord av Felix Hedenström och Jonathan Rinnarv
fib(0,0):- !.
fib(1,1):- !.

fib(N, F):-
	N > 0,
	K is (N - 1),
	fibHelp(K, F, 0, 1).

fibHelp(0, F, _, F):- !.

fibHelp(N, F, PREVIOUSLY, VALUE):-
	N1 is (N - 1),
	VALUE1 is (PREVIOUSLY + VALUE),
	fibHelp(N1, F, VALUE, VALUE1).

rovarsprak([],[]).	
rovarsprak([H|T1],[H,111,H|T2]):-
	not(member(H,[97,101,105,111,117,121])),
	!,
	rovarsprak(T1,T2).
rovarsprak([H|T1],[H|T2]):-
	rovarsprak(T1,T2).

medellangd([],0):- !.
medellangd(Text, AvgLen):- 
	!,
	helpLangd(Text,32, AvgLen, 0, 0).	

helpLangd([H|Tail]	, LastChar, AvgLen, Total, Gaps):-
	notLetter(H),
	notLetter(LastChar),
	!,
	helpLangd(Tail,H,AvgLen, Total, Gaps).

helpLangd([H|Tail]	, 		_, AvgLen, Total, Gaps):-
	notLetter(H),
	!,
	helpLangd(Tail, H, AvgLen, Total, (Gaps + 1)).

helpLangd([H|Tail]			, _, AvgLen, Total, Gaps):-
	!,
	helpLangd(Tail, H, AvgLen, (Total + 1), Gaps).

helpLangd([]				, LastChar, AvgLen, Total, Gaps):- 
	notLetter(LastChar),
	!,
	AvgLen is Total / Gaps.

helpLangd([]				, _, AvgLen, Total, Gaps):- 
	AvgLen is Total / (Gaps + 1).

notLetter(Char):-
	not(is_alpha(Char)). %member(Char,[32,33,46,39,38]).

%skyffla(Lista, Skyfflad) :- skyfflahelp()	
skyffla(Lista,Skyffla):-
	everyother(Lista,X),
	removeFirst(Lista,NewList),
	everyother(NewList,L),
	!,
	skyffla(L,Y),
	append(X,Y,Skyffla).
skyffla([],Skyffla):- Skyffla = [].

removeFirst([_|Tail],L):- L = Tail. 

everyother([H1,_|Tail],OutList):-
	everyother(Tail,L),
	append([H1],L,OutList).
everyother([],[]).
everyother(OneAtom, OutList):- OneAtom = OutList.
% Man kan inte ha en mainfunktion när man lämnar in på kattis då den inte fungerar i det fallet.