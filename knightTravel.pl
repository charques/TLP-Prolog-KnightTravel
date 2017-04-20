% crea un tablero vacio
tableroVacio(N,Board):- ct_aux(1,N,Board).

ct_aux(M,N,[]):- M > N, !.
ct_aux(M,N,[File|RF]):-
    columnaVacia(N,File), M1 is M+1, ct_aux(M1,N,RF).

columnaVacia(1,[true]):- !.
columnaVacia(N,[true|CV]):-
    N1 is N-1, columnaVacia(N1,CV).

% inicializa un tablero
initBoard(N,s(F,R),node(N,1,Board,s(F,R),[s(F,R)])):-
    tableroVacio(N,Board0),
    inBoard(N,s(F,R)),!,
    visitSquare(s(F,R),Board0,Board).

% Comprobar si la casilla s(F,R) está dentro de un tablero de tamaño N.
inBoard(N,s(F,R)):- F > 0, R > 0, F =< N, R =< N.

% Dada una casilla (s(F,R)), cambiar su valor a falso en un tablero dado (Board).
visitSquare(s(F,R),Board,BoardSol):-
    FileIndex is F-1,
    RankIndex is R-1,
    nth0(RankIndex, Board, Rank),
    replace(Rank, FileIndex, false, NewRank),
    replace(Board, RankIndex, NewRank, BoardSol).

% reemplaza el elemento I de la lista por el elemento X
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

% comprueba que para el tablero Board la casilla s(F,R) esta libre.
freeSquare(Board,s(F,R)):-
    nth1(R, Board, File),
    nth1(F, File, Value),
    %write('freeSquare: '), write(F), write(' '), write(R), write(' '), write(Value), nl,
    Value.

% comprueba que en el tablero (Board) de tamaño N, se puede ir a la casilla s(F,R),
% porque está en el tablero (inBoard) y está libre (freeSquare). Además coloca
% (pone a false esa posición en Board con visitSquare) el caballo en la posición s(F,R),
% construyendo el nuevo tablero (BoardNuevo).
validSquare(N,s(F,R),Board,BoardNuevo):-
    inBoard(N,s(F,R)),
    freeSquare(Board,s(F,R)),
    visitSquare(s(F,R),Board,BoardNuevo),
    write('validSquare: '), write(F), write(' '), write(R), write(' Old: '), write(Board), nl,
    write('validSquare: '), write(F), write(' '), write(R), write(' New: '), write(BoardNuevo), nl.

% para comprobar si en un nodo del espacio de búsqueda hay, o no, una solución, esto es, si contiene,
% o no, un camino completo (que recorra todo el tablero).
fullPath(node(N, PL, _, _, _)):- PL =:= N*N.

% comprueba que haya nodos sucesores a partir de Node y construye los movimientos posibles,
% de uno en uno, y comprobando si son casillas válidas (validSquare) y por lo tanto movimientos
% válidos que generan un nodo sucesor (NNode).
jump(Node, NNuevo):-
    write('jump 1: ' ), write(Node), nl,
    moveAux(Node,NNuevo),
    write('jump 2: ' ), write(NNuevo), nl, nl.
%jump(Node, NNuevo):- check(Node,-2,1), move(Node,-2,1,NNuevo).
%jump(Node, NNuevo):- check(Node,2,1), move(Node,2,1,NNuevo).
%jump(Node, NNuevo):- check(Node,2,-1), move(Node,2,-1,NNuevo).
%jump(Node, NNuevo):- check(Node,1,2), move(Node,1,2,NNuevo).
%jump(Node, NNuevo):- check(Node,1,-2), move(Node,1,-2,NNuevo).
%jump(Node, NNuevo):- check(Node,-1,2), move(Node,-1,2,NNuevo).
%jump(Node, NNuevo):- check(Node,-1,-2), move(Node,-1,-2,NNuevo).
%jump(Node, NNuevo):- false, !.
%NNuevo = node(0,0,[],s(0,0),[]).

moveAux(Node,NNuevo):-
    move(Node, -2,-1, NNuevo);
    move(Node, -2,1, NNuevo);
    move(Node, 2,1, NNuevo);
    move(Node, 2,-1, NNuevo);
    move(Node, 1,2, NNuevo);
    move(Node, 1,-2, NNuevo);
    move(Node, -1,2, NNuevo);
    move(Node, -1,-2, NNuevo).
    %back(Node, NNuevo), !, fail.
    %NNuevo = node(0,0,[],s(0,0),[]).
    %!, fail.


%IMPLEMENTAR FREE SQUARE DE OTRO MODO - COMO DICE EL ENUNCIADO

back(node(N,Length,Board,s(F,R),Path), NNuevo):-
    last(Path, Last),
    delete(Path, Last, NewPath),
    NewLength is Length-1,
    visitSquare2(Last,Board,NewBoard),
    write('back '), write(node(N,NewLength,NewBoard,Last,NewPath)), nl,
    NNuevo = node(N,NewLength,NewBoard,Last,NewPath).

visitSquare2(s(F,R),Board,BoardSol):-
    FileIndex is F-1,
    RankIndex is R-1,
    nth0(RankIndex, Board, Rank),
    replace(Rank, FileIndex, true, NewRank),
    replace(Board, RankIndex, NewRank, BoardSol).

check(node(N,_,Board,s(F,R),_), FOffset, ROffset):-
    FileIndex is F + FOffset,
    RankIndex is R + ROffset,
    inBoard(N,s(FileIndex,RankIndex)),
    freeSquare(Board,s(FileIndex,RankIndex)),
    write('check '), write(FileIndex), write(' '), write(RankIndex), write(' '), write(Board), nl.

move(node(N,Length,Board,s(F,R),Path), FOffset, ROffset, NNuevo):-
    write('move Board: '), write(Board), write(' '), write(FOffset), write(' '), write(ROffset), nl,
    FileIndex is F + FOffset,
    RankIndex is R + ROffset,
    NewLength is Length + 1,
    validSquare(N,s(FileIndex,RankIndex),Board,BoardNuevo), !,
    %write(FileIndex), write(' '), write(RankIndex), nl,
    append(Path,[s(FileIndex,RankIndex)],NewPath),
    NNuevo = node(N,NewLength,BoardNuevo,s(FileIndex,RankIndex),NewPath),
    write('move NNuevo: '), write(NNuevo), nl, nl.

% Es la función principal, que recibe un entero representando el tamaño del tablero,
% una casilla desde la que el caballo iniciará su recorrido y devuelve un camino que
% recorre todo el tablero comenzando por la casilla indicada. Si no hubiera solución,
% el camino devuelto sería vacío.
knightTravel(N,s(F,R)):-
    initBoard(N,s(F,R),node(N,1,Board,s(F,R),[s(F,R)])),
    recorrerBT(node(N,1,Board,s(F,R),[s(F,R)])).

% implementa la búsqueda de soluciones en profundudad con vuelta atrás con una la llamada recursiva.
% Siendo la condición de parada, encontrar un nodo solución (fullPath).
recorrerBT(Node):-
    fullPath(Node),
    write('result: '), write(Node).
recorrerBT(Node):-
    write('recorrerBT: '), write(Node), nl,
    jump(Node,NNuevo),
    recorrerBT(NNuevo).