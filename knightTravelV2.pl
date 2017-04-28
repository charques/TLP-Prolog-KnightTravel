% Crea un tablero vacio
tableroVacio(N,Board):- ct_aux(1,N,Board).

ct_aux(M,N,[]):- M > N, !.
ct_aux(M,N,[File|RF]):-
    columnaVacia(N,File), M1 is M+1, ct_aux(M1,N,RF).

columnaVacia(1,[true]):- !.
columnaVacia(N,[true|CV]):-
    N1 is N-1, columnaVacia(N1,CV).

% Inicializa un tablero
initBoard(N,s(F,R),node(N,1,Board,s(F,R),[s(F,R)])):-
    tableroVacio(N,Board0),
    inBoard(N,s(F,R)),!,
    visita(Board0,s(F,R),Board), !.

% Comprobar si la casilla s(F,R) está dentro de un tablero de tamaño N.
inBoard(N,s(F,R)):- F > 0, R > 0, F =< N, R =< N.

% Itera sobre las columnas del tablero para marcar la posicion indicada por s(F,R).
% Falla si la posicion indicada ya esta ocupada.
visita([Rank|T],s(F,1),[NewRank|T]):- visitaColumna(Rank, F, NewRank).
visita([H|T],s(F,R),[H|E]) :- R > 1, NR is R-1, visita(T,s(F,NR),E).

% Itera sobre la columna para sustituir el valor si Value = true.
% Si Value = false, falla indicando que la posicion está ocupada.
visitaColumna([Value|T],1,[false|T]):- Value.
visitaColumna([H|T],P,[H|R]) :- P > 1, NP is P-1, visitaColumna(T,NP,R).

% Comprueba que en el tablero (Board) de tamaño N, se puede ir a la casilla s(F,R).
% Chequea que la posicion está en el tablero (inBoard) y posteriormente trata de hacer el movimiento (visita).
% El predicado visita devuelve false si la posicion ya esta ocupada.
validSquare(N,s(F,R),Board,BoardNuevo):-
    inBoard(N,s(F,R)),
    visita(Board,s(F,R),BoardNuevo).

% Comprueba que el camino sea completo.
fullPath(node(N, PL, _, _, _)):- PL =:= N*N.

% Comprueba que haya nodos sucesores a partir de Node y genera el nodo sucesor (NNode).
% Delega en possibleKnightMove la contruccion de los movimientos y en move la validacion de
% que el movimiento es correcto y en caso satisfactorio la generacion del nuevo nodo.
jump(node(N,Length,Board,s(F,R),Path), NNuevo):-
    possibleKnightMove(s(F,R), s(F1,R1)),
    move(node(N,Length,Board,s(F,R),Path), s(F1,R1), NNuevo).

% Construye los posibles movimientos en base a una posicion s(F,R).
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+1, R1 is R+2.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+2, R1 is R+1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+2, R1 is R-1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F+1, R1 is R-2.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-1, R1 is R-2.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-2, R1 is R+1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-2, R1 is R-1.
possibleKnightMove(s(F,R), s(F1,R1)) :- F1 is F-1, R1 is R+2.

% Valida que un movimiento es correcto y encaso afirmativo, genera el nuevo nodo.
move(node(N,Length,Board,_,Path), s(F1,R1), NNuevo):-
    validSquare(N,s(F1,R1),Board,BoardNuevo), !,
    NewLength is Length + 1,
    add(s(F1,R1),Path,NewPath),
    NNuevo = node(N,NewLength,BoardNuevo,s(F1,R1),NewPath).

% Aniade un elemento a la cabecera de la lista.
add(X,L2,[X|L2]).

% Muestra el path por consola. Antes de mostrarlo le da la vuelta ya que el predicado move
% inserta los movimientos en la cabecera del Path.
showPath(node(_,_,_,_,Path)):-
    reverse(Path, ReversePath),
    write(ReversePath), nl.

% Es la función principal, que recibe un entero representando el tamaño del tablero,
% una casilla desde la que el caballo iniciará su recorrido y devuelve un camino que
% recorre todo el tablero comenzando por la casilla indicada. Si no hubiera solución,
% el camino devuelto sería vacío.
knightTravel(N,s(F,R)):-
    initBoard(N,s(F,R),Node),
    recorrerBT(Node);
    write([]), nl.

% Implementa la búsqueda de soluciones en profundudad con vuelta atrás con una la llamada recursiva.
% Siendo la condición de parada, encontrar un nodo solución (fullPath).
% En caso de encontrar solucion la muestra por consola.
recorrerBT(Node):-
    fullPath(Node),
    showPath(Node).
recorrerBT(Node):-
    jump(Node,NNuevo),
    recorrerBT(NNuevo).