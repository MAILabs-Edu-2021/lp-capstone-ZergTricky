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

both(Z, A, B):-
    parent(A, Z),
    parent(B, Z).
marriage(A, B):-
    bagof(Z, both(Z,A,B), _).



relation('son', A, B):-
    parent(B, A),
    sex(A, 'M').

relation('daughter', A, B):-
    parent(B, A),
    sex(A, 'F').
relation('father', A, B):-
    parent(A, B),
    sex(A, 'M').
relation('mother', A, B):-
    parent(A, B),
    sex(A, 'F').
relation('brother', A, B):-
    sibling(A, B),
    sex(A, 'M').
relation('sister', A, B):-
    sibling(A, B),
    sex(A, 'F').
relation('second brother', A, B):-
    second_cousin(A, B),
    sex(A, 'M').
relation('second sister', A, B):-
    second_cousin(A, B),
    sex(A, 'F').
relation('husband', A, B):-
    marriage(A,B),
    sex(A, 'M').
relation('wife', A, B):-
    marriage(A,B),
    sex(A, 'F').


move(A, B):-
    parent(A, B);
    parent(B, A);
    sibling(A, B);
    second_cousin(A, B);
    marriage(A, B).

prolong([X|T],[Y,X|T]):-
    move(X, Y), not(member(Y,[X|T])).

bfs([[X|T]|_], X, [X|T]).
bfs([X|Q], T, P):-
    findall(Z, prolong(X, Z), L),
    append(Q, L, Q1), !,
    bfs(Q1, T, P).
bfs([_|Q], T, P):-
    bfs(Q, T, P).

bfs_search(X, Y, P):-
    bfs([[X]], Y, P1),
    reverse(P1, P).

write_path([A, B|T]):-
    relation(S, A, B),
    write(S),
    write(" of "),
    write_path([B|T]).
write_path(_).

find_relation(X, Y):-
    bfs_search(X, Y, P),
    write(X),
    write(" is "),
    write_path(P),
    !,
    write(Y),
    write(".\n").