% Определение алфавита для меток вершин
% Используется фиксированный список букв [a, b, c, d, e, f, g], из которого будут браться первые P букв для вершин.
% Это ограничивает максимальное P до 7. Для больших P нужно расширить алфавит.
alphabet([a, b, c, d, e, f, g]).

% Вспомогательные предикаты из graphs(1).pl, используемые для работы со списками:

% in_list/2: Проверяет, содержится ли элемент El в списке, и возвращает его.
% Работает рекурсивно: если El — первый элемент, возвращает его; иначе проверяет хвост списка.
in_list([El|_], El).
in_list([_|T], El) :- in_list(T, El).

% append1/3: Конкатенация списков, аналог append/3 в стандартной библиотеке.
% База: если первый список пуст, результат — второй список.
% Рекурсия: добавляет голову первого списка к результату конкатенации хвоста и второго списка.
append1([], X, X) :- !.
append1([H|T], X, [H|Z]) :- append1(T, X, Z).

% subtract/3: Удаляет из первого списка все элементы, содержащиеся во втором, возвращает результат.
% Если элемент из первого списка есть во втором, он пропускается; иначе добавляется в результат.
subtract([], _, []) :- !.
subtract([H|T], L, R) :- member(H, L), !, subtract(T, L, R).
subtract([H|T], L, [H|R]) :- subtract(T, L, R).

% get_vertices/2: Получение списка из P вершин из алфавита.
% Выбирает первые P элементов из алфавита, используя append1 для разделения списка.
% Например, для P=3 вершины будут [a, b, c].
get_vertices(P, Vertices) :-
    alphabet(A),
    length(Vertices, P),           % Устанавливает длину списка Vertices равной P
    append1(Vertices, _, A).       % Vertices — первые P элементов алфавита A

% all_possible_edges/2: Генерация всех возможных дуг для заданного множества вершин.
% Для каждой пары вершин (U, V), где U ≠ V, создается дуга [U, V].
% Использует findall для сбора всех таких пар в список AllEdges.
all_possible_edges(Vertices, AllEdges) :-
    findall([U, V], (in_list(Vertices, U), in_list(Vertices, V), U \= V), AllEdges).

% pq_graph_recursive/3: Основной предикат для рекурсивной генерации (p, q)-графов.
% Принимает список вершин и Q (число дуг), возвращает граф как список дуг.
% Сначала генерирует все возможные дуги, затем вызывает вспомогательный предикат.
pq_graph_recursive(Vertices, Q, Graph) :-
    all_possible_edges(Vertices, AllEdges),
    pq_graph_recursive_helper(AllEdges, Q, [], Graph).

% pq_graph_recursive_helper/4: Вспомогательный предикат для рекурсивной генерации.
% Параметры:
% - Edges: Список оставшихся доступных дуг.
% - Q: Число дуг, которые еще нужно выбрать.
% - Acc: Накопленный список выбранных дуг (аккумулятор).
% - Graph: Финальный результат — список из Q дуг.
% База: Если Q = 0, возвращаем накопленный список как результат.
% Рекурсия: Выбираем дугу, исключаем её из доступных, уменьшаем Q, продолжаем.
pq_graph_recursive_helper(_, 0, Acc, Acc) :- !.
pq_graph_recursive_helper(Edges, Q, Acc, Graph) :-
    Q > 0,
    in_list(Edges, Edge),                     % Выбираем дугу Edge из списка Edges
    subtract(Edges, [Edge], RestEdges),       % Удаляем выбранную дугу из Edges
    Q1 is Q - 1,                              % Уменьшаем счетчик дуг
    pq_graph_recursive_helper(RestEdges, Q1, [Edge|Acc], Graph).

% write_pq_graph_recursive_to_file/3: Запись всех (p, q)-графов в файл.
% Открывает файл для записи, генерирует графы рекурсивно и записывает их построчно.
% Использует fail для генерации всех решений, затем закрывает файл.
write_pq_graph_recursive_to_file(P, Q, File) :-
    get_vertices(P, Vertices),
    open(File, write, Stream),
    (   pq_graph_recursive(Vertices, Q, Graph),
        write(Stream, Graph), nl(Stream),
        fail                                  % Заставляет искать следующее решение
    ;   true                                  % Завершает цикл после всех решений
    ),
    close(Stream).

% main_pq_graph/2: Основной предикат для запуска генерации.
% Выводит сообщение о начале, вызывает запись в файл, затем сообщает об окончании.
% Принимает P (число вершин) и Q (число дуг) как параметры.
main_pq_graph(P, Q) :-
    write('Starting pq_graph_recursive...'), nl,
    write_pq_graph_recursive_to_file(P, Q, 'pq_graphs_recursive.txt'),
    write('Done!'), nl.