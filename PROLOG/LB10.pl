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
