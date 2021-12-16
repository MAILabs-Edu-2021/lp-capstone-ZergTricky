:- ['pred.pl'].

get_list_item([A|_], 0, A).
get_list_item([_|T], N, R):-
    N1 is N - 1,
    get_list_item(T, N1, R).

comma([]):-!.
comma(_):-
    write(', '),!.

print_item([]).

print_item([A|T]):-
    write(A),
    comma(T),
    print_item(T).

print_list([]):-
    write('None'),
    write('\n').

print_list(X):-
    print_item(X).

ask_question(S):-
    parse_many(X, S),
    get_list_item(X, 1, Relation),
    get_list_item(X, 3, Who),
    findall(V, relation(Relation, V, Who), L),
    length(L,L1),
    write(L1),
    write(': '),
    print_list(L),
    !.

ask_question(S):-
    parse_what(X, S),
    get_list_item(X, 3, A),
    get_list_item(X, 5, B),
    find_relation(A, B),!.

ask_question(S):-
    parse_who_is(X, S),
    get_list_item(X, 1, I),
    atom_concat(Who,'\'s', I),
    get_list_item(X, 2, Relation),
    findall(P, relation(Relation, P, Who), L),
    print_list(L),!.

ask_question(S):-
    parse_whose(X, S),
    get_list_item(X, 1, Relation),
    get_list_item(X, 3, Who),
    findall(P, relation(Relation, Who, P), L),
    print_list(L),!.
    
sentence_many --> many, relation_many, auxiliary, person, verb, sign. % How many [relatives] does [someone] have ? 
sentence_what --> what, ['relations'], ['between'], person, ['and'], person, sign. % What relations between [A] and [B]?
sentence_who_is --> who_is, person_who_is, relation_who_is, sign.    % Who is [person] [relative] ?
sentence_whose --> whose, relation_who_is, ['is'], person, sign. % Whose [relation] is [person] ?

parse_many(X, S):-
    sentence_many(X, []),
    atomic_list_concat(X,' ', Y),
    atom_string(Y, S).

parse_what(X, S):-
    sentence_what(X, []),
    atomic_list_concat(X,' ', Y),
    atom_string(Y, S).

parse_who_is(X, S):-
    sentence_who_is(X, []),
    atomic_list_concat(X,' ', Y),
    atom_string(Y, S).

parse_whose(X, S):-
    sentence_whose(X, []),
    atomic_list_concat(X,' ', Y),
    atom_string(Y, S).

many --> ['How many'].
many --> ['how many'].

what --> ['What'].
what --> ['what'].

who_is --> ['Who is'].
who_is --> ['who is'].

whose --> ['Whose'].
whose --> ['whose'].

relation_many --> ['brothers'].
relation_many --> ['sisters'].
relation_many --> ['children'].

relation_who_is --> ['father'].
relation_who_is --> ['mother'].
relation_who_is --> ['daughter'].
relation_who_is --> ['son'].
relation_who_is --> ['brother'].
relation_who_is --> ['sister'].
relation_who_is --> ['second sister'].
relation_who_is --> ['second brother'].
relation_who_is --> ['wife'].
relation_who_is --> ['husband'].

auxiliary --> ['does'].

sign --> ['?'].

verb --> ['have'].

person_who_is([A|X], X):-
    sex(Y,_),
    atom_concat(Y, '\'s', A).

person([A|X], X):-
    sex(A, _).