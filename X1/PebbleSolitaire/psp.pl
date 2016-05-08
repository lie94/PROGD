%Authur Jonathan Rinnarv
%		Felix Hedenström

[kattio].
% Read number of boards and start reading boards
main :-
	read_int(Nr_Of_Boards),
	proccessBoard(Nr_Of_Boards).

% All boards have been processed, shut down.
proccessBoard(0).

% There are boards left to analyse
proccessBoard(Nr_Of_Boards):-
	read_string(Board),							% Read board
	findLowest(Board, Lowest_Nr_Of_Pebbles), 	% Find lowest possible number of pebbels left
	write(Lowest_Nr_Of_Pebbles),				% Print the number
	nl,											% new line
	!,
	N is (Nr_Of_Boards - 1),					% Lower the number of boards left
	proccessBoard(N).

% 45 is the ASCII code for '-'
% 111 is the ASCII code for 'o'
% Find lowest possible number of pebbels left
findLowest(Board, Lowest_Nr_Of_Pebbles):- 	
	helpFind(Board, [], 0, 12, Lowest1),					% Look through the board with only moves to the right
	reverse(Board, RevBoard),
	helpFind(RevBoard, [], 0, 12, Lowest2),					% Look through the board with only moves to the left, initiate the number of pebbles counted as 0, guess the lowest number of pebbles as 12
	setLowest(Lowest1,Lowest2,Lowest_Nr_Of_Pebbles).		% Did we get the lowest result by a move to the left or to the right?

helpFind([], _, Counter, LowestGuess, Lowest_Nr_Of_Pebbles):- 	% We have looked through all pebbels
	setLowest(Counter, LowestGuess, Lowest_Nr_Of_Pebbles). 					% Are there no moves left or was there a move that lowered the number of pebbels

% Iterate through the pebbels, counting them and trying all possible moves along the way
helpFind([A|T], PreviousAtoms, Counter, LowGuess, Lowest_Nr_Of_Pebbles):-
	A = 111,				% The current position has a pebble
	N is Counter + 1,		% Count it
	mutate(T, PreviousAtoms, MutateLowestGuess), 		% Check to se if we can move the pebble and recursivly check deeper moves
	append(PreviousAtoms, [A], NewPrev),					% Add the pebble to the list of previous positions checked
	setLowest(LowGuess, MutateLowestGuess, NewGuess),	% Check if a move from this pebble results in the lowest number of pebbles found so far
	helpFind(T, NewPrev, N, NewGuess, Lowest_Nr_Of_Pebbles).	% Move up one pebble and repeat

helpFind([A|T], PreviousAtoms, Counter, LowGuess, Lowest_Nr_Of_Pebbles):-
	A = 45,													% The current position does not hold a pebble
	append(PreviousAtoms, [A], NewPrev),						% Add the position to the array of previously visited positions
	helpFind(T, NewPrev, Counter, LowGuess, Lowest_Nr_Of_Pebbles).	% Move forward one position and repeat


% Try to move the pebble, update the board and try to find a low number of pebbels using the new board.
mutate([B,C|T], PreviousAtoms, LowestGuess):-
	B = 111, 	
	C = 45,										% The next two pebbels allow you to make a move
	append(PreviousAtoms, [45,45,111|T], L),	% Create a new board
	findLowest(L, LowestGuess).					% Try to find new lowest number

% No move available
mutate(_, _, 12).					


% Set the third input to be the same as the lower of the two previous inputs
setLowest(Lowest1, Lowest2, Lowest1):-
	Lowest1 < Lowest2.
setLowest(_, Lowest2, Lowest2).