:- ['family.pl'].

sibling(A,B):-
    parent(X,B),
    sex(X,'M'),
    parent(X,A),
    A \= B.

second_cousin(A,B):-
    parent(X,B),
    parent(Y,X),
    sibling(Y,Z),
    parent(Z,H),
    parent(H,A).