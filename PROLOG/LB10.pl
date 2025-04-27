% Генерация всех размещений с повторениями
razm_povt(_, 0, Razm, Razm) :- !.
razm_povt(Alphabet, NCur, RazmCur, Razm) :-
    in_list(Alphabet, El), % Выбираем элемент из алфавита
    NNew is NCur - 1,      % Уменьшаем количество оставшихся позиций
    razm_povt(Alphabet, NNew, [El | RazmCur], Razm).

% Проверка наличия элемента в списке
in_list([El | _], El).
in_list([_ | T], El) :- in_list(T, El).

%Базовый случай: когда размер подмножества равен 0, выводим пустое множество
sochet([], _, 0) :- !.

%Рекурсивный случай: выбираем элемент из алфавита и продолжаем строить подмножество
sochet([H|Sub_set], [H|Set], K) :-
    K1 is K - 1,
    sochet(Sub_set, Set, K1).  % Рекурсивно строим сочетание

%Рекурсивный случай: продолжаем строить подмножество без использования текущего элемента
sochet(Sub_set, [H|Set], K) :-
    sochet(Sub_set, Set, K).  % Рекурсивно строим сочетание без H

make_pos_list(K, K, []):-!.
make_pos_list(K, CurPos, [NewPos|TailPos]) :- NewPos is CurPos + 1, make_pos_list(K, NewPos, TailPos).

make_3a_empty_word(K, K, _, []):-!.
make_3a_empty_word(K, CurIndex, [NewIndex|PosTail], [a|Tail]) :- 
    NewIndex is CurIndex + 1, make_3a_empty_word(K, NewIndex, PosTail, Tail),!.
make_3a_empty_word(K, CurIndex, PosList, [_|Tail]) :- 
    NewIndex is CurIndex + 1, make_3a_empty_word(K, NewIndex, PosList, Tail).   

build_word([],[],_):-!.
build_word([a|WordTail],[X|WordEmpty3aTail],RestWord) :- 
    nonvar(X),build_word(WordTail,WordEmpty3aTail,RestWord),!.
build_word([Y|WordTail],[X|WordEmpty3aTail],[Y|RestWordTail]) :- 
    var(X),build_word(WordTail,WordEmpty3aTail,RestWordTail).

build_3a_words_of_k(Alphabet,K,Word) :- make_pos_list(K, 0, PosList), 
    sochet(Pos_a_List, PosList, 3), make_3a_empty_word(K, 0, Pos_a_List, WordEmpty3a), Alphabet = [a|NewAlphabet], 
    M is K - 3, razm_povt(NewAlphabet, M, [], RestWord), build_word(Word, WordEmpty3a, RestWord).

% Функция для вывода всех размещений
generate_all_razm(Alphabet, K) :-
    razm_povt(Alphabet, K, [], Razm),  % Генерация одного размещения
    write(Razm), nl,                   % Печатаем размещение
    fail.  % Продолжаем искать следующее размещение

generate_all_razm(_, _) :- !.  % Завершаем, когда все размещения выведены

% Функция для вывода всех сочетаний
generate_all_sochet(Alphabet, K) :-
    sochet(Sub_set, Alphabet, K),  % Генерация одного сочетания
    write(Sub_set), nl,            % Выводим сочетание
    fail.                          % Продолжаем искать следующее сочетание

generate_all_sochet(_, _) :- !.   % Завершаем, когда все сочетания выведены

% Чтение строки из файла и поиск максимальной длины строки
max_line_length(File, MaxLength) :-
    open(File, read, Stream),  % Открытие файла для чтения
    read_lines(Stream, 0, MaxLength),  % Чтение строк и нахождение максимальной длины
    close(Stream).  % Закрытие файла

% Рекурсивное чтение строк из файла и вычисление максимальной длины
read_lines(Stream, MaxSoFar, MaxLength) :-
    read_line_to_string(Stream, Line),  % Чтение строки из файла
    (   Line == end_of_file  % Если конец файла
    ->  MaxLength = MaxSoFar  % Возвращаем максимальную длину
    ;   string_length(Line, Len),  % Вычисляем длину строки
        NewMax is max(MaxSoFar, Len),  % Обновляем максимальную длину
        read_lines(Stream, NewMax, MaxLength)  % Рекурсивно обрабатываем остальные строки
    ).

% Предикат для подсчета строк, не содержащих пробелы
count_lines_without_spaces(File, Count) :-
    open(File, read, Stream),  % Открытие файла для чтения
    count_no_spaces(Stream, 0, Count),  % Чтение строк и подсчет строк без пробелов
    close(Stream).  % Закрытие файла

% Рекурсивное чтение строк из файла и подсчет строк без пробелов
count_no_spaces(Stream, CountSoFar, Count) :-
    read_line_to_string(Stream, Line),  % Чтение строки из файла
    (   Line == end_of_file  % Если конец файла
    ->  Count = CountSoFar  % Возвращаем количество строк без пробелов
    ;   (   \+ sub_string(Line, _, 1, _, ' ')  % Проверка на отсутствие пробела
        ->  NewCount is CountSoFar + 1  % Увеличиваем счетчик, если нет пробела
        ;   NewCount is CountSoFar
        ),
        count_no_spaces(Stream, NewCount, Count)  % Рекурсивно обрабатываем остальные строки
    ).

% Предикат для подсчета строк, в которых букв "a" больше, чем в среднем на строку
find_lines_with_more_a_than_avg(File) :-
    open(File, read, Stream),  % Открытие файла для чтения
    count_lines_and_a(Stream, 0, 0, TotalLines, TotalA),  % Подсчитываем количество строк и букв "a"
    (TotalLines > 0 -> 
        Avg is TotalA / TotalLines,  % Находим среднее количество букв "a" на строку
        write('Average number of a\'s per line: '), write(Avg), nl,  % Выводим среднее
        find_lines_above_avg(Stream, Avg); 
        write('No lines found in the file.')
    ),
    close(Stream).  % Закрытие файла

% Подсчет количества строк и букв "a" в файле
count_lines_and_a(Stream, TotalLines, TotalA, FinalTotalLines, FinalTotalA) :-
    read_line_to_string(Stream, Line),  % Чтение строки из файла
    (   Line == end_of_file  % Если конец файла
    ->  FinalTotalLines = TotalLines,
        FinalTotalA = TotalA
    ;   count_a_in_line(Line, ACount),  % Подсчитываем количество букв "a" в строке
        NewTotalA is TotalA + ACount,  % Обновляем общий счетчик букв "a"
        NewTotalLines is TotalLines + 1,  % Увеличиваем счетчик строк
        count_lines_and_a(Stream, NewTotalLines, NewTotalA, FinalTotalLines, FinalTotalA)  % Рекурсивный вызов
    ).

% Подсчет количества букв "a" в строке
count_a_in_line(Line, ACount) :-
    string_lower(Line, LowerCaseLine),  % Преобразуем строку в нижний регистр
    string_chars(LowerCaseLine, Chars),  % Преобразуем строку в список символов
    count_a_chars(Chars, 0, ACount).  % Подсчитываем количество "a"

% Рекурсивный подсчет количества букв "a" в списке символов
count_a_chars([], ACount, ACount).
count_a_chars([H|T], Acc, ACount) :-
    (   H = 'a'
    ->  NewAcc is Acc + 1
    ;   NewAcc is Acc
    ),
    count_a_chars(T, NewAcc, ACount).

% Функция для вывода строк с буквами "a" больше, чем в среднем
find_lines_above_avg(Stream, Avg) :-
    read_line_to_string(Stream, Line),  % Чтение строки из файла
    (   Line == end_of_file  % Если конец файла, завершение
    ->  true
    ;   count_a_in_line(Line, ACount),  % Подсчитываем количество букв "a"
        write('Line: '), write(Line), nl,  % Выводим строку
        write('Number of a\'s: '), write(ACount), nl,  % Выводим количество букв "a" в строке
        (   ACount > Avg  % Если букв "a" в строке больше, чем в среднем
        ->  write('This line has more a\'s than the average'), nl  % Сообщение, если больше
        ;   write('This line does not have more a\'s than the average'), nl  % Иначе
        ),
        find_lines_above_avg(Stream, Avg)  % Рекурсивный вызов
    ).

% Определение алфавита
alphabet([a, b, c, d, e, f, g]).

% --- 1. Размещения без повторений (A(7,3)) ---

% Рекурсивный метод
arrangement(Alphabet, K, Arr) :-
    length(Arr, K),
    arrangement_helper(Alphabet, Arr).

arrangement_helper([], []).
arrangement_helper(Alphabet, [H|T]) :-
    select(H, Alphabet, Rest),
    arrangement_helper(Rest, T).

% Нерекурсивный метод
all_arrangements(Alphabet, K, AllArr) :-
    findall(Arr, arrangement(Alphabet, K, Arr), AllArr).

% Запись в файлы
write_arrangements_recursive_to_file(Alphabet, K, File) :-
    open(File, write, Stream),
    (   arrangement(Alphabet, K, Arr),
        write(Stream, Arr), nl(Stream),
        fail
    ;   true
    ),
    close(Stream).

write_all_arrangements_to_file(Alphabet, K, File) :-
    all_arrangements(Alphabet, K, AllArr),
    (   AllArr = [] -> write('No arrangements generated for non-recursive method.'), nl
    ;   open(File, write, Stream),
        maplist(writeln(Stream), AllArr),
        close(Stream)
    ).

% --- 2. Подмножества ---

% Рекурсивный метод
subset([], []).
subset([H|T], [H|Sub]) :-
    subset(T, Sub).
subset([_|T], Sub) :-
    subset(T, Sub).

% Нерекурсивный метод
all_subsets(Alphabet, AllSub) :-
    findall(Sub, subset(Alphabet, Sub), AllSub).

% Запись в файлы
write_subsets_recursive_to_file(Alphabet, File) :-
    open(File, write, Stream),
    (   subset(Alphabet, Sub),
        write(Stream, Sub), nl(Stream),
        fail
    ;   true
    ),
    close(Stream).

write_all_subsets_to_file(Alphabet, File) :-
    all_subsets(Alphabet, AllSub),
    (   AllSub = [] -> write('No subsets generated for non-recursive method.'), nl
    ;   open(File, write, Stream),
        maplist(writeln(Stream), AllSub),
        close(Stream)
    ).

% --- 3. Слова длины 5: одна буква повторяется 2 раза, остальные уникальны ---

% Нерекурсивный метод
words5_non_recursive(Alphabet, Words) :-
    findall(Word, generate_word5(Alphabet, Word), Words).

generate_word5(Alphabet, Word) :-
    member(RepeatChar, Alphabet),
    Positions = [0, 1, 2, 3, 4],
    subset(PosSubset, Positions),
    length(PosSubset, 2),
    subtract(Positions, PosSubset, RemPositions),
    subtract(Alphabet, [RepeatChar], OtherAlphabet),
    length(OtherAlphabet, Len), Len >= 3, % Проверка, что достаточно символов
    findall(ThreeChars, (combination(3, OtherAlphabet, ThreeChars)), ThreeCharsList),
    member(ThreeChars, ThreeCharsList),
    permutation(ThreeChars, Perm),
    length(Word, 5),
    maplist({RepeatChar}/[Pos]>>nth0(Pos, Word, RepeatChar), PosSubset),
    maplist({Perm}/[Idx, Pos]>>nth0(Idx, Perm, Char), nth0(Pos, Word, Char), RemPositions).

combination(0, _, []) :- !.
combination(K, [H|T], [H|Comb]) :-
    K > 0,
    K1 is K - 1,
    combination(K1, T, Comb).
combination(K, [_|T], Comb) :-
    K > 0,
    combination(K, T, Comb).

% Рекурсивный метод
words5_recursive(Alphabet, Word) :-
    member(RepeatChar, Alphabet),
    subtract(Alphabet, [RepeatChar], OtherAlphabet),
    combination(3, OtherAlphabet, ThreeChars),
    length(Word, 5),
    append([RepeatChar, RepeatChar], ThreeChars, WordList),
    permutation(WordList, Word).

% Запись в файлы
write_words5_recursive_to_file(Alphabet, File) :-
    open(File, write, Stream),
    (   words5_recursive(Alphabet, Word),
        write(Stream, Word), nl(Stream),
        fail
    ;   true
    ),
    close(Stream).

write_words5_non_recursive_to_file(Alphabet, File) :-
    words5_non_recursive(Alphabet, Words),
    (   Words = [] -> write('No words5 generated for non-recursive method.'), nl
    ;   open(File, write, Stream),
        maplist(writeln(Stream), Words),
        close(Stream)
    ).

% --- 4. Слова длины 7: одна буква повторяется 2 раза, одна — 3 раза ---

% Нерекурсивный метод
words7_non_recursive(Alphabet, Words) :-
    findall(Word, generate_word7(Alphabet, Word), Words).

generate_word7(Alphabet, Word) :-
    member(Repeat2Char, Alphabet),
    member(Repeat3Char, Alphabet),
    Repeat2Char \= Repeat3Char,
    Positions = [0, 1, 2, 3, 4, 5, 6],
    subset(Pos2Subset, Positions),
    length(Pos2Subset, 2),
    subtract(Positions, Pos2Subset, RemPositions1),
    subset(Pos3Subset, RemPositions1),
    length(Pos3Subset, 3),
    subtract(RemPositions1, Pos3Subset, RemPositions2),
    subtract(Alphabet, [Repeat2Char, Repeat3Char], OtherAlphabet),
    length(OtherAlphabet, Len), Len >= 2, % Проверка, что достаточно символов
    combination(2, OtherAlphabet, TwoChars),
    length(Word, 7),
    maplist({Repeat2Char}/[Pos]>>nth0(Pos, Word, Repeat2Char), Pos2Subset),
    maplist({Repeat3Char}/[Pos]>>nth0(Pos, Word, Repeat3Char), Pos3Subset),
    maplist({TwoChars}/[Idx, Pos]>>nth0(Idx, TwoChars, Char), nth0(Pos, Word, Char), RemPositions2).

% Рекурсивный метод
words7_recursive(Alphabet, Word) :-
    member(Repeat2Char, Alphabet),
    member(Repeat3Char, Alphabet),
    Repeat2Char \= Repeat3Char,
    subtract(Alphabet, [Repeat2Char, Repeat3Char], OtherAlphabet),
    combination(2, OtherAlphabet, TwoChars),
    length(Word, 7),
    append([Repeat2Char, Repeat2Char], [Repeat3Char, Repeat3Char, Repeat3Char], RepPart),
    append(RepPart, TwoChars, WordList),
    permutation(WordList, Word).

% Запись в файлы
write_words7_recursive_to_file(Alphabet, File) :-
    open(File, write, Stream),
    (   words7_recursive(Alphabet, Word),
        write(Stream, Word), nl(Stream),
        fail
    ;   true
    ),
    close(Stream).

write_words7_non_recursive_to_file(Alphabet, File) :-
    words7_non_recursive(Alphabet, Words),
    (   Words = [] -> write('No words7 generated for non-recursive method.'), nl
    ;   open(File, write, Stream),
        maplist(writeln(Stream), Words),
        close(Stream)
    ).

% --- Основной предикат ---
main :-
    alphabet(Alphabet),
    write('Starting arrangements_recursive...'), nl,
    write_arrangements_recursive_to_file(Alphabet, 3, 'arrangements_recursive.txt'),
    write('Starting arrangements_non_recursive...'), nl,
    write_all_arrangements_to_file(Alphabet, 3, 'arrangements_non_recursive.txt'),
    write('Starting subsets_recursive...'), nl,
    write_subsets_recursive_to_file(Alphabet, 'subsets_recursive.txt'),
    write('Starting subsets_non_recursive...'), nl,
    write_all_subsets_to_file(Alphabet, 'subsets_non_recursive.txt'),
    write('Starting words5_recursive...'), nl,
    write_words5_recursive_to_file(Alphabet, 'words5_recursive.txt'),
    write('Starting words5_non_recursive...'), nl,
    write_words5_non_recursive_to_file(Alphabet, 'words5_non_recursive.txt'),
    write('Starting words7_recursive...'), nl,
    write_words7_recursive_to_file(Alphabet, 'words7_recursive.txt'),
    write('Starting words7_non_recursive...'), nl,
    write_words7_non_recursive_to_file(Alphabet, 'words7_non_recursive.txt'),
    write('Done!'), nl.