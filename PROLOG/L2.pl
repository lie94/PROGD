%Author Felix Hedenström och Jonathan Rinnarv
spider(X):-
	findall(Y,person(Y),L),
	person(X),
	subspider(X,L).
subspider(X,L):-
	getConspirators(X,Conspirators),
	%check(Conspirators),
	hasConnection(L,Conspirators,X),
	!.

getConspirators(PotentialSpider,PotentialConspirators):-
	findall(X,helpKnows(PotentialSpider,X),L1),
	!,
	subConspirators(L1,PotentialConspirators).
subConspirators([H|Tail],[H|ReturnList]):-
	findall(X,helpKnows(H,X),HFriends),
	subtract(Tail,HFriends,Rest),
	subConspirators(Rest,ReturnList).
subConspirators([_|Tail],ReturnList):-
	subConspirators(Tail, ReturnList).
subConspirators([],[]).

hasConnection([],_,_):- !.
hasConnection([H|Tail],BadGuys,Spider):-
	not(member(H,BadGuys)),
	not(Spider = H),
	!,
	friends(BadGuys,H),
	hasConnection(Tail,BadGuys,Spider).

hasConnection([_|Tail],BadGuys,Spider):-
	!,
	hasConnection(Tail,BadGuys,Spider).

friends([],_):- false.
friends([H|_],Atom):-
	helpKnows(H,Atom),
	!.
friends([_|Tail],Atom):-
	friends(Tail,Atom).

helpKnows(X,Y):-
	knows(X,Y);knows(Y,X).

% Hitta spindlar!
% Ta alla som s känner. A_1 = [a_1...a_n]

% Ta första elementet ur listan av listan av A_1, a_0
% Kolla om a_0 känner någon i listan A_1 \ a_0, gör en lista med alla fall där a_1 inte känner någon i den nya listan A_2

% Ta första elementet i A_2, a_1 och ta bort alla element ur A_2 så att a_1 känner det elementet.
% När detta är gjort har du kvar en lista med potentiella konspiratörer
% Gör en lista av de element som du tagit bort, gör samma sak med dem, då de också är potentiella konspiratörer.

% Kolla om alla andra element i listan över totala antalet personer känner någon av de potentiella konspiratörerna eller spinden själv.
% Om de gör det har du hittat en potentiell spindel.