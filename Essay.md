# Реферат
## по курсу "Логическое программирование"

### студент: Белоусов Е.В.

## Типовые и бестиповые логические языки: обзор и сравнение.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

### Что такое типизация и зачем она нужна
Типизацией в языках программирования называют, то как эти самые языки распознают типы переменных. Разделять переменные на различные вполне естественно, например, в реальной жизни мы раскладываем наши вещи по их типу. Использование типов помогает компилятору понять, как переменные должны взаимодействовать друг с другом.

  Изначально идея типизации появилась именно в традиционных ЯП, во времена зарождения языков программирования память была сильно ограничена и нельзя было каждой переменной выдавать большой кусок в памяти, но и мало памяти давать тоже нельзя, так как может потребоваться больше чем, к примеру, 1 байт. Была еще проблема: что должно произойти, если сложить число и символ? Конечно, можно было разрешить компилятору решать такие вопросы самостоятельно, но ведь из-за этого могли возникнуть неопределенные ситуации. Поэтому было решено ввести каждому значению свой тип.

Если говорить простым языком: в традиционных ЯП тип говорит от том, что можно делать с конкретным значением:
поведение при определенных операциях, например при сложении целого и символьного типа, какую информацию это значение может иметь. Например, у строк есть операция конкатенации, строки принимают набор символов, который заканчивается терминирующим знаком.

Языки программирования различают по строгости типизации:
* Бестиповая типизация, такая типизация в основном присутствует в старых языках таких как Basic, Wolfram Mathematica. В такой типизации все данные представляют собой  последовательность битов различной длины. Так мы можем применять любые операции между любыми двумя типами. 
* Сильная типизация, в такой типизации типы строго соблюдаются. Например, переменные разных типов нельзя никак "смешивать".
* Слабая типизация, в таком случае можно применять операции между разными типами, тогда язык программирования сам будет стараться привести один тип к другому, но, если один тип нельзя привести к другому или наоборот, то происходит ошибка.

Так уж получилось, что сегодня доминируют языки с сильной и слабой типизацией. Строгая типизация используется в сферах, где важна надежность, слабая типизация используется, когда нужно написать какое-то решение задачи достаточно быстро и программист понимает, что операции с разными типами никак не повлияют на результат.

Есть еще одно разделение языков:
* Статическая типизация
* Динамическая типизация

В первом случае каждой переменной на этапе компиляции привязывается какой-то тип, если программист на языке C++ захочет сделать так:
```cpp
int a = 10;
a = "abacaba"
```
То он получит ошибку компиляции. Динамическая типизация не привязывает каждой переменной свой тип, это оказывается очень удобным. Например, в языке Python можно написать такое выражение:
```python
a = 10
a = "Hello world!"
```
И никаких проблем не возникнет.

Понятно, что языки со статической типизацией работают быстрее и надежнее, но обычно такие языки являются более трудными для изучения, поэтому сегодня такие языки с динамической типизацией, как Python, JavaScript, Scala оказываются очень популярными.

### Применение типизации в логических языках

Однако мир логического программирования стоит особняком и не содержит очень много общего с традиционными языками программирования. В логических языках не требуется выделять память под переменные, так как переменная представляет собой ссылку на структуру данных, которая может быть самой разной: от примитива до сложных структурных термов. Переменная является несколько непредсказуемой, по этой причине мы не можем точно сказать, сколько памяти понадобится для такой переменной выделить. В таком случае возникает вопрос: зачем нужна типизация в логических языках? Один из плюсов типизации – это избегание множества ошибок. Классический пример, с которым сталкивался каждый, кто работал с Prolog: мы создали предикат, задали, какие переменные должны идти в каком порядке, но вот нам потребовалось создать предикат очень похожий данный, мы просто скопируем его и поменяем чуть структуру, в таком случае мы можем столкнуться с проблемой: мы забыли поменять порядок аргументов в сигнатуре. Нам повезет, если программа завершится с какой-то ошибкой, в таком случае мы можем быстро найти проблему, но не редко предикат отработает, но выполнит свою задачу совсем не так, как мы ожидали, тогда мы может и не поймем, что ошибка кроется в конкретном предикате. К сожалению компилятор не в состоянии справиться с  проблемой такого типа, так как Пролог не привязывает каждому терму конкретный тип. Можно использовать некоторые дополнения, которые превращают бестиповые языки в языки со строгой типизацией. Также существуют логические языки, в которых есть строгая и статическая типизация, например, VisualProlog

Типизация делает код более лаконичным, в будущем такой код намного проще поддерживать. Также наличие типизации помогает с отлавливанием багов.


### Обзор логических языков

#### Prolog

Prolog является одним из самых известных логических языков. Одной из отличительных особенностей Пролога является отсутствие типизации, т.е. Пролог – это бестиповый язык. Для хранения чего-угодно в Прологе используется универсальный тип данных – терм. Термы можно разделить на простые и структурные. Простые делятся на переменные и константы. В конце концов константы делятся на атомы и числа.

Атом – это отдельный объект, считающийся элементарным. Переменные обозначаются строкой состоящей из букв и цифр, строка обязательно должна начинаться на заглавную букву или подчеркивание, в ином случае это будет считаться атомом. Также существует так называемый структурный терм, он состоит из нескольких аргументов, содержащихся в круглых скобках, арностью структурного терма называют количество этих аргументов.

Также невозможно представить Пролог без использования списков и строк. 

Список – это просто упорядоченный набор термов, он является чрезвычайно важным, так как может хранить сколько угодно элементов. Список имеет две части: голова и хвост. Голова – это первый элемент списка, а хвост – все остальное.

Строки представляют собой просто последовательность Unicode символов.

На Прологе легко написать что-то достаточно трудное всего в пару строк! Это делает его несколько похожим на популярный язык Python. Безусловно отсутствие типизации и делает Пролог настолько удобным и простым в понимании. Поэтому сегодня его часто использует для знакомства с логическим программированием.

#### Mercury
Mercury – это язык программирования общего назначения, первоначально разработанный и реализованный
небольшой группой исследователей из Мельбурнского университета, Австралия. Mercury
основан на парадигме чисто декларативного программирования и был разработан, чтобы быть полезным
для разработки больших и надежных приложений “реального мира”. Он улучшает существующие
языки логического программирования, обеспечивая повышенную производительность, надежность и эффективность,
а также устраняя необходимость в нелогичных программных конструкциях. Mercury обеспечивает традиционный-функциональный синтаксис логического программирования, но также обеспечивает синтаксическое удобство определяемых пользователем
функций, плавно интегрируя логику и функциональное программирование в единую парадигму.
Mercury требует, чтобы программисты предоставляли объявления типа, режима и детерминизма для
предикатов и функций, которые они пишут. Компилятор проверяет эти объявления и отклоняет
программу, если он не может доказать, что каждый предикат или функция удовлетворяют его объявлениям. Это
повышает надежность, так как многие виды ошибок просто не могут произойти из-за того, что они отпадут еще во время компиляции. Это также повышает производительность, поскольку компилятор выявляет множество
ошибок, для обнаружения которых в противном случае потребовалась бы ручная отладка. Тот факт, что объявления
проверяются компилятором, делает их гораздо более полезными, чем комментарии для всех, кто
должен поддерживать программу. Компилятор также использует гарантированную корректность
объявлений для значительного повышения эффективности генерируемого кода.
Для облегчения программирования в целом, обеспечения возможности отдельной компиляции и поддержки
инкапсуляции, Mercury имеет простую модульную систему. Стандартная библиотека Mercury содержит
множество предопределенных модулей для общих задач программирования.

Синтаксис Mercury сильно схож с синтаксисом Пролога, с несколькими дополнительными определениями для типов, режимов, детерминизма, системы модулей. Программа на Mercury состоит из несколько модулей, каждый модуль представляет собой файл, который состоит определений и правил. Mercury использует грамматику для правил, подобную Прологу.

В Mercury существуют такие типы:
* Примитивы: int, float, char, string
* Предикаты
* Кортежи
* Функции
* univ (Универсальный тип)


#### VisualProlog 

Visual Prolog 7.5 — это строго типизированный объектно-ориентированный язык, основанный на парадигме логического программирования. Visual Prolog является хорошим вариантом для обучения студентов вузов, но это не делает его исключительно образовательным: ничего не мешает использовать Visual Prolog для создания приложений. Одной из особенностей языка является то, что компилятор для Visual Prolog написан на самом же Visual Prolog. Но сканер и парсер языка реализованы на C++.
Visual Prolog имеет множество особенностей:
* предложения Хорна как основа логического программирования
* поддержка объектно-ориентированного программирования
* наличие строгой и статической типизации
* наличие предикатов и функций высших порядков, а также анонимных предикатов и функций
* обработка исключений
* наличие многопоточности, а также синхронизации потоков
* наличие сборщика мусора
* поддержка линкования с кодом C/C++

Строгий контроль типов, отсутствие арифметических манипуляций с указателями, сборщик мусора позволяют Visual Prolog создавать безопасные и надежные программы. 

Visual Prolog является языком со статической типизацией. Как уже ранее упоминалось, из статической типизации следует два факта: контроль типов осуществляет во время компиляции, а также совместимость типов должна быть явно указана или наследована при определении типа.
К слову, Visual Prolog является единственным Прологом, у которого присутствует статическая типизация. Из этого вытекает несколько преимуществ перед, например, обычным Прологом:
* Visual Prolog выигрывает в скорости
* Код становится более надежным. Компилятор проверяет соответствие типов и запрещает унификацию разных термов.

Типы данных в Visual Prolog разделяются на типы объектов и типы данных. Типы объектов – это часть ООП, поэтому, для избежания загромождения, они описаны не будут.

Тип данных в Visual Prolog определяет множество значений, которые переменная принимает, а также операции, которые можно выполнять с ней. Помимо этого в Visual Prolog есть понятие домена. В области баз данных под доменом имеют ввиду все атомарные значения, которые может принимать поле.

Более строгое определение домена:

Домен — именованное множество значений некоторого типа данных или других
доменов, которое имеет смысловое значение, выражаемое его именем.

Использование доменов позволяет проводить строгий контроль типов, благодаря этому на этапе компиляции удается обнаружить почти все синтаксические и смысловые ошибки.

Рассмотрим детально домены, которые присутствуют в Visual Prolog:
* any — универсальный домен. Этот домен представляет собой ссылку на библиотеку доменов термов и непосредственно терм.
* binary — последовательность байтов. Этот домен используется для хранения двоичных данных.
* binaryNotAtomic — то же самое, что и binary, но может содержать указатели.
* boolean — булевое значение. Принимает два значения: true/false.
* char — двухбайтовый символ.
* compareResult — домен, который используется, для получения результата сравнения двух термов. Принимает три значения: меньше(less), больше(greater) и равно (equal).
* integer — целое число со знаком, занимает четыре байта. К этому домену применяются арифметические операции: сложение, вычитание, умножение, деление и т.д. Также применяются операции сравнения, унификации.
* integer64 — то же самое что и integer, но занимает 8 байтов в памяти, поэтому имеет большие диапазон значений.
* integerNative — целые числа со знаком. Диапазон этого типа зависит от платформы.
* pointer — указатель на адрес памяти. Значение ссылается на адрес в памяти. К этому домену применяются операции равенства. Существует специальная константа null, которая обозначает нулевой адрес, это значит, что указатель не указывает на что-то определенное и поэтому с ним нельзя работать.
* real — число с плавающей точкой. Занимает 8 байтов в памяти.
* real32 — то же самое, что и real, но занимает 4 байта в памяти.
* string — последовательность символов (char). К string применима унификация.
* unsigned — целые числа без знака.
* unsigned64 — то же самое, что и unsigned, но занимает 8 байтов в памяти.

### Вывод

Мир логического программирования представляет множество различных инструментов, задача программиста — правильно этими инструментами воспользоваться. Можно воспользоваться Visual Prolog, в таком случае человеку будет легко писать большой проект с множеством различных модулей. Не нужно забывать и о скорости, Visual Prolog работает быстрее бестиповых аналогов. Типизация в Visual Prolog позволяет не беспокоиться о неправильной унификации термов, так как все ошибки с неправильными типами будут отловлены еще во время компиляции. С другой стороны разработчик может воспользоваться Prolog, тогда проблемы с унификацией могут возникнуть, но, если нужно написать какой-то маленький по размеру проект, то времени человек потратит намного меньше. Ввиду своей простоты использование бестиповых языков лучше подходит для обучения, так как не нужно думать о проблемах типизации. 

### Литература

1. A type system for logic programms. Eyal Yardeni. Ehud Shapiro
2. On Types and Type Consistency in Logic Programming. Gregor Meyer
3. The Mercury Language Reference Manual. Fergus Henderson (2011)
4. Современное логическое программирование на языке Visual Prolog 7.5 Марков В.Н.(2015)