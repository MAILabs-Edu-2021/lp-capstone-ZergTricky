# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Белоусов Егор Владимирович

## Результат проверки

Вариант задания:

 - [ ] стандартный, без NLP (на 3)
 - [x] стандартный, с NLP (на 3-4)
 - [ ] продвинутый (на 3-5)
 
| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |    27.12.21          |      4.5         |
| Левинская М.А.|              |               |


## Введение

В первую очередь я научился конвертировать файлы типа GEDCOM используя Python. Также я научился создавать запросы на прологе для проверки связей между людьми.

## Задание

1. Создать родословное дерево на несколько (3-4) поколения назад в стандартном формате GEDCOM.
2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: предикаты `parent(родитель, ребенок)`, `sex(человек, M/F)`.
3. Реализовать предикат проверки/поиска троюродных братьев/сестер.

## Получение родословного дерева

Я использовал уже готовое дерево родословной Романовых. Я решил не брать очень большое дерево, оставив только 3 поколения из чуть более, чем 30 людей.
 
## Конвертация родословного дерева

Я решил использовать язык Python для конвертации файла GEDCOM. Python идеально подходит для парсинга(конвертации) различных файлов, поэтому я выбрал именно его.

В первую очередь я открыл два файла для ввода и вывода:
```python
IN = open("./family.ged", "r", encoding="utf8")
OUT = open("./family.pl", "w", encoding="utf8")
```
Потом я начал считывать файл построчно: если в строке присутствует "INDI", тогда началось объявление нового родственника, в таком случае я запоминаю для его ID его имя и пол:
```python
for line in IN:
    line = line[:-1]
    if line[len(line) - 1] == '/':
        pos = -1
        for i in range(0, len(line)):
            if line[i] == '/':
                pos = i
                break
        line = line[:pos - 1]
    words = line.split(" ")
    if words[len(words) - 1] == "INDI":
        lastId = words[1]
        people[lastId] = {"name": "", "sex": ""}
        P[lastId] = {}
        P[lastId]["children"] = []
        cur = cur + 1
    if words[1] == "NAME" and lastId != -1:
        people[lastId]["name"] = line[7:]
    if words[1] == "SEX" and lastId != -1:
        people[lastId]["sex"] = words[2]
```

Затем, когда в файле GEDCOM начинается перечисляться семейные пары, я смотрю ID двух родителей и добавляю к ним всех детей:
```python
   if words[1] == "HUSB" or words[1] == "WIFE":
        parents.append(words[2])
    if words[1] == "CHIL":
        children.append(words[2])
    if words[len(words) - 1] == "FAM":
        if len(children) > 0:
            for parent in parents:
                for child in children:
                    P[parent]["children"].append(child)
        children = []
        parents = []
```

В конце я вывожу все предикаты `parent` и `sex`:
```python
for item in people:
    OUT.write("sex(\'" + people[item]["name"] + "\', " + "\'" + people[item]["sex"] + "\').\n")

for parent in people:
    for child in P[parent]["children"]:
        OUT.write("parent(\'" + people[parent]["name"] + "\', " + "\'" + people[child]["name"] + "\'" + ").\n")
```

## Предикат поиска родственника

Так как мне требуется найти троюродную связь, то я сперва поднимаюсь до всех бабушек/дедушек. Затем я смотрю на всех братьев и сестер (для этого есть специальный предикат `sibling`)
Для каждого брата/сестры смотрю всех внуков.

```prolog
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
```

Пример работы:
```prolog
?- second_cousin('Ольга Николаевна',X).
X = 'Мария Кирилловна' ;
X = 'Кира Кирилловна' ;

?- sibling('Ольга Николаевна',X).
X = 'Татьяна Николаевна' ;
X = 'Мария Николаевна' ;
X = 'Анастасия Николаевна' ;
X = 'Алексей Николаевич' ;

?- second_cousin('Алексей Николаевич',X).
X = 'Мария Кирилловна' ;
X = 'Кира Кирилловна' ;

?- second_cousin(X,'Мария Кирилловна').
X = 'Ольга Николаевна' ;
X = 'Татьяна Николаевна' ;
X = 'Мария Николаевна' ;
X = 'Анастасия Николаевна' ;
X = 'Алексей Николаевич' ;

?- second_cousin('Николай 2',X).
X = 'Олег Константинович' ;
X = 'Игорь Константинович' ;
X = 'Вера Константиновна' ;

?- sibling('Олег Константинович',X).
X = 'Игорь Константинович' ;
X = 'Вера Константиновна' ;
```

## Определение степени родства

Предикат ```find_relation(X, Y)``` выводит информацию о связи между X и Y. Так как связи между родственниками можно представить в виде графа, тогда можно использовать алгоритм поиска для нахождения "пути" от одного человека до другого. Я использовал поиск в ширину.
Для начала требуется задать ребра:
```prolog
move(A, B):-
    parent(A, B);
    parent(B, A);
    sibling(A, B);
    second_cousin(A, B);
    marriage(A, B).
```
Теперь реализуем сам поиск в ширину:
```prolog
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
```
Сам предикат ``` find_relation(X, Y)```, а также предикаты для вывода.
```prolog
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
```
Пример работы:
```prolog
?- find_relation('Николай 2', 'Алексей Николаевич').
Николай 2 is father of Алексей Николаевич.

?- find_relation('Алексей Николаевич', 'Николай 2').
Алексей Николаевич is son of Николай 2.

?- find_relation('Николай 2', 'Владимир Александрович').
Николай 2 is son of brother of Владимир Александрович.

?- find_relation('Татьяна Николаевна', 'Мария Павловна').
Татьяна Николаевна is second sister of daughter of son of Мария Павловна.
```

## Естественно-языковый интерфейс

Я реализовал поддержку четырех вопросов: сколько родственников определенного типа у конкретного человека, какие отношения между двумя родственниками, кто является определенным родственником для конкретного человека, и для кого конкретный человек является определенным родственникам. Для начала нужно понять, что за вопрос был задан. Для этого используется 4 предиката в 
DC-грамматике:
```prolog
sentence_many --> many, relation_many, auxiliary, person, verb, sign. % How many [relatives] does [someone] have ? 
sentence_what --> what, ['relations'], ['between'], person, ['and'], person, sign. % What relations between [A] and [B]?
sentence_who_is --> who_is, person_who_is, relation_who_is, sign.    % Who is [person] [relative] ?
sentence_whose --> whose, relation_who_is, ['is'], person, sign. % Whose [relation] is [person] ?
```
Потом для удобства я разбиваю строку по словам:
```prolog
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
```
Для получения ответа на вопрос используется предикат ```ask_question```, который использует вышеперечисленные предикаты. Реализация для 4 случаев:
```prolog
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
``` 
Пример работы:
```prolog
?- ask_question('How many brothers does Николай 2 have ?').
3: Георгий Александрович, Михаил Александрович, Александр Александрович
true.

?- ask_question('How many children does Николай 2 have ?').
5: Ольга Николаевна, Татьяна Николаевна, Мария Николаевна, Анастасия Николаевна, Алексей Николаевич
true.

?- ask_question("Who is Татьяна Николаевна's father ?").
Николай 2
true.

?- ask_question("Who is Татьяна Николаевна's mother ?").
Александра Федоровна
true.

?- ask_question("Who is Николай 2's wife ?").
Александра Федоровна
true.

?- ask_question("What relations between Мария Александровна and Николай 2 ?").
Мария Александровна is mother of father of Николай 2.
true.

?- ask_question("What relations between Мария Павловна and Николай 2 ?").
Мария Павловна is mother of second brother of second brother of Николай 2.
true.

?- ask_question("Whose mother is Александра Федоровна ?").
Ольга Николаевна, Татьяна Николаевна, Мария Николаевна, Анастасия Николаевна, Алексей Николаевич
true.
```
## Выводы

Благодаря курсовому проекту я познакомился поглубже с Прологом. Для начала было интересно разработать парсер на Python для родословного дерева, сперва я думал написать парсер на Прологе, но это оказалось неудобным, поэтому я использовал язык, который лучше подходит для данной задачи.

Особенно заинтересовала меня задача создания предиката для определения степени родства двух родственников. В решении я использовал навыки, полученные во время выполнения 3 лабораторной работы: я свел задачу к поиску пути в графе, в этом мне помог алгоритм поиска в ширину.

Возможности Пролога для реализации интерфейса обработки естественного языка оказались для меня неожиданными. Ранее я думал, что для решения такой нетривиальной задачи нужно использовать мощные языки с большим количеством библиотек, например Python, но возможности Prolog делают эту задачу тривиальной.

Единственным недочетом я могу отметить производительность Пролога: если загрузить огромное родословное дерево, то придется ждать несколько секунд для получения ответа на какой-то вопрос. Но этот недочет компенсирует удобство разработки.
