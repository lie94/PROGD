%Någon vars alla bekanta inte känner varandra.
/*spider(X):-
	findall(Z,person(Z),L). % Potential spiders */
spider(X):-
	findall(Y,person(Y),L),
	person(X),
	subspider(X,L).
subspider(X,L):-
	getConspirators(X,Conspirators),
	append([X],Conspirators,BadGuys),
	hasConnection(L,BadGuys),
	!.


hasConnection([],_).
hasConnection([H|Tail],BadGuys):-
	not(member(H,BadGuys)),
	!,
	friends(BadGuys,H),
	hasConnection(Tail,BadGuys).

hasConnection([_|Tail],BadGuys):-
	!,
	hasConnection(Tail,BadGuys).

getConspirators(PotentialSpider, PotentialConspirators):-
	findall(X,helpKnows(PotentialSpider,X),L1),
	subConspirators(L1,Z),
	without(L1,Z,L2),
	!,
	dual(Z,L2,PotentialConspirators).



dual(L2,[],L2):- !.
dual([],L1,L1):- !.
dual(L2,_,L2).
dual(_,L1,L1).

subConspirators([],[]):- !.

subConspirators([H|Tail],[H|ReturnList]):-
	not(friends(Tail, H)),
	!,
	subConspirators(Tail, ReturnList).

subConspirators([_|Tail],ReturnList):- % Vi behöver spara de som inte är friends och undersöka dem.
	!,
	subConspirators(Tail,ReturnList).

friends([],_):- false.
friends([H|_],Atom):-
	helpKnows(H,Atom).
friends([_|Tail],Atom):-
	friends(Tail,Atom).

without([H|Tail1],List,[H|Tail2]):- 
	not(member(H,List)), 
	!,	
	without(Tail1,List,Tail2).
without([_|Tail1],List,NewList):-
	without(Tail1,List,NewList).
without([],_,[]):- !.


helpKnows(X,Y):-
	knows(X,Y);knows(Y,X),
	not(X = Y).

% Hitta spindlar!
% Ta alla som s känner. A_1 = [a_1...a_n]

% Ta första elementet ur listan av listan av A_1, a_0
% Kolla om a_0 känner någon i listan A_1 \ a_0, gör en lista med alla fall där a_1 inte känner någon i den nya listan A_2

% Ta första elementet i A_2, a_1 och ta bort alla element ur A_2 så att a_1 känner det elementet.
% När detta är gjort har du kvar en lista med potentiella konspiratörer
% Gör en lista av de element som du tagit bort, gör samma sak med dem, då de också är potentiella konspiratörer.







% Kolla om alla andra element i listan över totala antalet personer känner någon av de potentiella konspiratörerna eller spinden själv.
% Om de gör det har du hittat en potentiell spindel.