%Authur Jonathan Rinnarv
%		Felix Hedenström

[kattio].

main :-
	read_int(W), read_int(_),  	% Read the width W as the first input, the second input is not used
	getArray(New_walls),		% Reads all integers to create an array of walls		
	append(New_walls,[W],All_walls), % Append the width to the array of walls
	solve(All_walls, [0|All_walls], Solution), 	% Find an array of all combinations of walls
	sort(Solution, Z),							% Sort and remove duplicates
	atomic_list_concat(Z, ' ', S),				% Create string with spaces between the numbers
	write(S), nl.								% Print the result and a newline

% A list of no walls returns a solution with no atoms
solve([], _, []):- !.


% Iterate through each wall and combine it with other walls
solve([H|T], OriginalList, NewSolution):-
	getAllLengths(H, OriginalList, Z),	% Creates a list of the width of all walls combined with wall H
	append(Z, Solution, NewSolution),	% Add Z to the solution list
	solve(T, OriginalList, Solution).	% Iterate to the next wall

getAllLengths(_, [], []):- !.		% There are no walls left that can be matched

% First argument is a wall, second is the list of all walls, third is the list of all results of the combinations
getAllLengths(X, [H|T], [Z|Result]):-
	H < X,			% H is smaller than X
	!,			
	Z is X - H,			
	getAllLengths(X, T, Result).

% If H is not smaller than X, keep moving through the array.
getAllLengths(X, [_|T], Result):-
	getAllLengths(X, T, Result).


% Read an array of ints from the inputs
getArray(T):-
			read_int(P),
			!,
			helpGetArray(P,T).

% We have reached the end of the file
helpGetArray(end_of_file,[]).

% Reads all integer inputs to create an array
helpGetArray(P,[P|T]):-
			not(P = end_of_file),
			read_int(Q),
			!,
			helpGetArray(Q,T).