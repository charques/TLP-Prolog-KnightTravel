quiere(juan,elena).
quiere(manuel,elena).
celoso(X,Y):-
    quiere(X,T),
    quiere(Y,T),
    X\==Y.

p(X,Y):- X>15, !, write('ok1'), Y<20, write('ok2').
p(X,Y):- X > Y, write('ok3').