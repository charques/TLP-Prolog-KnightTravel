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
    visitSquare(s(F,R),Board0,Board), !.

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
    Value.

%visita(s(F,R),Board,BoardNuevo):-


% comprueba que en el tablero (Board) de tamaño N, se puede ir a la casilla s(F,R),
% porque está en el tablero (inBoard) y está libre (freeSquare). Además coloca
% (pone a false esa posición en Board con visitSquare) el caballo en la posición s(F,R),
% construyendo el nuevo tablero (BoardNuevo).
validSquare(N,s(F,R),Board,BoardNuevo):-
    inBoard(N,s(F,R)),
    %visita(s(F,R),Board,BoardNuevo).
    freeSquare(Board,s(F,R)),
    visitSquare(s(F,R),Board,BoardNuevo).

% para comprobar si en un nodo del espacio de búsqueda hay, o no, una solución, esto es, si contiene,
% o no, un camino completo (que recorra todo el tablero).
fullPath(node(N, PL, _, _, _)):- PL =:= N*N.

% comprueba que haya nodos sucesores a partir de Node y construye los movimientos posibles,
% de uno en uno, y comprobando si son casillas válidas (validSquare) y por lo tanto movimientos
% válidos que generan un nodo sucesor (NNode).
jump(Node, NNuevo):-
    node(N,Length,Board,s(F,R),Path) = Node,
    possibleKnightMove(s(F,R), s(F1,R1)),
    move(node(N,Length,Board,s(F,R),Path), s(F1,R1), NNuevo).

% construye los posibles movimientos
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+1, R1 is R+2.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+2, R1 is R+1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+2, R1 is R-1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+1, R1 is R-2.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-1, R1 is R-2.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-2, R1 is R+1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-2, R1 is R-1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-1, R1 is R+2.

% contruye un nuevo nodo para el primera posición válida
move(node(N,Length,Board,_,Path), s(F1,R1), NNuevo):-
    validSquare(N,s(F1,R1),Board,BoardNuevo),
    write(s(F1,R1)),
    NewLength is Length + 1,
    append(Path,[s(F1,R1)],NewPath),
    NNuevo = node(N,NewLength,BoardNuevo,s(F1,R1),NewPath).

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
    jump(Node,NNuevo),
    recorrerBT(NNuevo).