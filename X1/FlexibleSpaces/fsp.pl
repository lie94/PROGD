



[kattio].

main :-
	read_int(W), read_int(P),
	getArray(New_walls),
	write(W),
	write(P),
	append(New_walls,[W],All_walls),
	solve(All_walls, [0|All_walls], Solution),
	write(Solution).


solve([], _, [3]):- !.

solve([T|H], OriginalList, Solution):-
	member(A,OriginalList),
	A < T,
	Z is T - A,
	%not(member(Z, TempSolution)),
	solve(H, OriginalList, [Z|Solution]).

getArray(T):-
			read_int(P),
			!,
			helpGetArray(P,T).

helpGetArray(end_of_file,[]).

helpGetArray(P,[P|T]):-
			not(P = end_of_file),
			read_int(Q),
			!,
			helpGetArray(Q,T).



%			(P == end_of_file,
%			T = []);
%			getArray(T).
%solve(X, Y) :- 
% Z is abs(X-Y),
% write(Z), nl.