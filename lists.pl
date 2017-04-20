% tamaño listas
% cargar: [lists].
% probar: size([bill,ted,ming,pascal,nat,ron],N).

size([],0).
size([H|T],N) :- size(T,N1), N is N1+1.
%  or size([_|T],N) :- size(T,N1), N is N1+1.