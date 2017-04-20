
inBoard(5,s(0,5)). -> false
inBoard(5,s(5,0)). -> false
inBoard(5,s(1,1)). -> true
inBoard(5,s(5,5)). -> true
inBoard(5,s(5,6)). -> false

visitSquare(s(3,3),[[true,true,true],[true,true,true],[true,true,true]], BoardSol).
    -> BoardSol = [[true, true, true], [true, true, true], [true, true, false]].

visitSquare(s(2,1),[[true,true,true],[true,true,true],[true,true,true]], BoardSol).
    -> BoardSol = [[true, false, true], [true, true, true], [true, true, true]].

visitSquare(s(3,2),[[true,true,true],[true,true,true],[true,true,true]], BoardSol).
    -> BoardSol = [[true, true, true], [true, true, false], [true, true, true]].

visitSquare(s(1,1),[[true,true,true],[true,true,true],[true,true,true]], BoardSol).
    -> BoardSol = [[false, true, true], [true, true, true], [true, true, true]].


initBoard(3,s(1,1),node(N,1,Board,s(F,R),[s(F,R)])).
    -> N = 3,
       Board = [[false, true, true], [true, true, true], [true, true, true]],
       F = R, R = 1 .

freeSquare([[true, true,true],[true,true,true],[true,true,false]],s(3,3)).
    -> false.

freeSquare([[true, true,true],[true,true,true],[true,true,false]],s(3,2)).
    -> true.

freeSquare([[true, true,true],[true,true,true],[true,true,false]],s(1,1)).
    -> true.

validSquare(3,s(1,1),[[true, true,true],[true,true,true],[true,true,false]],BoardNuevo).
    -> BoardNuevo = [[false, true, true], [true, true, true], [true, true, false]] .

validSquare(3,s(3,3),[[true, true,true],[true,true,true],[true,true,false]],BoardNuevo).
    -> false.

fullPath(node(3,1,[],s(1,1),[s(1,1)])).
    -> false
fullPath(node(3,9,[],s(1,1),[s(1,1)])).
    -> true

TODO: jump
jump(node(3,1,[[false,true,true],[true,true,false],[true,true,true]],s(1,1),[s(1,1)]),NNuevo).

jump(node(5,1,[[true,true,true,true,true],[true,true,true,true,true],[true,true,false,true,true],[true,true,true,true,true],[true,true,true,true,true]],s(3,3),[s(3,3)]),NNuevo)
jump(node(5,1,[[true,true,true,true,true],[true,true,true,true,true],[true,true,false,true,true],[false,true,true,true,true],[true,true,true,true,true]],s(3,3),[s(3,3)]),NNuevo)


move(node(3,1,[[false, true,true],[true,true,true],[true,true,true]],s(1,1),[s(1,1)]), 2, 1, NNuevo).
    -> NNuevo = node(3, 2, [[false, true, true], [true, true, false], [true, true, true]], s(3, 2), [s(1, 1), s(3, 2)]).



?- knightTravel(3,s(1,1)).
node(3,9,[[false,false,false],[false,true,false],[false,false,false]],s(3,1),[s(1,1),s(3,2),s(1,3),s(2,1),s(3,3),s(1,2),s(3,1),s(2,3),s(3,1)])
true

jump(node(3,8,[[false,false,false],[false,true,false],[false,false,false]],s(2,3),[s(1,1),s(3,2),s(1,3),s(2,1),s(3,3),s(1,2),s(3,1),s(2,3)]), NNuevo)


jump(node(3,8,[[false,false,false],[false,true,false],[false,false,false]],s(2,3),[s(1,1),s(3,2),s(1,3),s(2,1),s(3,3),s(1,2),s(3,1),s(2,3)]), NNuevo)