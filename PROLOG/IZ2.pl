% Определение алфавита
alphabet([a, b, c, d, e, f, g]).                    % Задает метки для вершин

% Вспомогательные предикаты из graphs(1).pl
in_list([El|_], El).                                % Возвращает голову списка как элемент
in_list([_|T], El) :- in_list(T, El).               % Рекурсивно ищет элемент в хвосте
append1([], X, X) :- !.                             % Объединяет пустой список с X
append1([H|T], X, [H|Z]) :- append1(T, X, Z).       % Добавляет голову к результату объединения
subtract([], _, []) :- !.                           % Пустой список дает пустой результат
subtract([H|T], L, R) :- member(H, L), !, subtract(T, L, R).  % Исключает голову, если она в L
subtract([H|T], L, [H|R]) :- subtract(T, L, R).     % Сохраняет голову, если её нет в L

% Получение списка вершин
get_vertices(P, Vertices) :-                        % Формирует список из P вершин
    alphabet(A),                                    % Получает алфавит
    length(Vertices, P),                            % Устанавливает длину списка P
    append1(Vertices, _, A).                        % Берет первые P меток из алфавита

% Генерация всех возможных дуг
all_possible_edges(Vertices, AllEdges) :-           % Создает список всех дуг [U, V]
    findall([U, V], (in_list(Vertices, U), in_list(Vertices, V)), AllEdges).  % Собирает все пары, включая петли

% Рекурсивный метод генерации (p, q)-графов
pq_graph_recursive(Vertices, Q, Graph) :-           % Генерирует граф с Q дугами
    all_possible_edges(Vertices, AllEdges),         % Получает все возможные дуги
    pq_graph_recursive_helper(AllEdges, Q, [], Graph).  % Запускает рекурсию с пустым аккумулятором

pq_graph_recursive_helper(_, 0, Acc, Acc) :- !.     % Возвращает накопленный граф при Q=0
pq_graph_recursive_helper(Edges, Q, Acc, Graph) :-  % Рекурсивно выбирает дуги
    Q > 0,                                          % Проверяет, что нужно выбрать дуги
    in_list(Edges, Edge),                           % Выбирает одну дугу
    subtract(Edges, [Edge], RestEdges),             % Исключает выбранную дугу
    Q1 is Q - 1,                                    % Уменьшает счетчик дуг
    pq_graph_recursive_helper(RestEdges, Q1, [Edge|Acc], Graph).  % Продолжает рекурсию с новой дугой

% Запись в файл с сортировкой дуг для устранения дублирования
write_pq_graph_recursive_to_file(P, Q, File) :-     % Записывает графы в файл
    get_vertices(P, Vertices),                      % Получает P вершин
    MaxEdges is P * P,                              % Вычисляет максимум дуг: P^2
    (   Q > MaxEdges                                % Проверяет, допустимо ли Q
    ->  write('Error: Q exceeds maximum possible edges ('), write(MaxEdges), write(').'), nl  % Выводит ошибку, если Q большое
    ;   open(File, write, Stream),                  % Открывает файл для записи
        findall(SortedGraph, (                      % Собирает все графы
            pq_graph_recursive(Vertices, Q, Graph), % Генерирует граф
            sort(Graph, SortedGraph)                % Сортирует дуги для канонического порядка
        ), Graphs),                                 % Формирует список графов
        list_to_set(Graphs, UniqueGraphs),          % Удаляет дубликаты графов
        maplist(writeln(Stream), UniqueGraphs),     % Записывает каждый граф в файл
        close(Stream)                               % Закрывает файл
    ).                                              % Завершает условный оператор

% Основной предикат
main_pq_graph(P, Q) :-                              % Запускает генерацию и запись
    write('Starting pq_graph_recursive...'), nl,    % Сообщает о начале работы
    write_pq_graph_recursive_to_file(P, Q, 'pq_graphs_recursive.txt'),  % Вызывает запись в файл
    write('Done!'), nl.                             % Сообщает о завершении