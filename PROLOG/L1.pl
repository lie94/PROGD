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
	rovarsprak(T1,T2),
	!.	
rovarsprak([H|T1],[H|T2]):-
	rovarsprak(T1,T2).

medellangd(Text, AvgLen) :- AvgLen = 1.0.



skyffla(Lista, Skyfflad) :- Skyfflad = Lista.
% Man kan inte ha en mainfunktion när man lämnar in på kattis då den inte fungerar i det fallet.