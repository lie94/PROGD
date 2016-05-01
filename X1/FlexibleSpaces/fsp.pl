%Authur Jonathan Rinnarv
%		Felix Hedenström

[kattio].

main :-
	read_int(W), read_int(P),
	removeSingeltonError(P),
	getArray(New_walls),
	append(New_walls,[W],All_walls),
	solve(All_walls, [0|All_walls], Solution),
	sort(Solution, Z),
	atomic_list_concat(Z, ' ', S),
	write(S), nl.

removeSingeltonError(P):- 
		P > 0,
		!.

solve([], _, []):- !.

solve([H|T], OriginalList, NewSolution):-
	getAllLengths(H, OriginalList, Z),
	append(Z, Solution, NewSolution),
	solve(T, OriginalList, Solution).

getAllLengths(_, [], []):- !.

getAllLengths(X, [H|T], [Z|Result]):-
	H < X,
	!,
	Z is X - H,
	getAllLengths(X, T, Result).

getAllLengths(X, [_|T], Result):-
	getAllLengths(X, T, Result).

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

%appendUnique([], OriginalList, OriginalList):- !.

%appendUnique([H|T], OriginalList, [H|Result]):-
%	not(member(H, OriginalList)),
%	!,
%	appendUnique(T, OriginalList, Result).

%appendUnique([_|T], OriginalList, Result):-
%	appendUnique(T, OriginalList, Result).