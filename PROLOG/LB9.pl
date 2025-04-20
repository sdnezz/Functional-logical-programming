% Максимальное число трех%
max(X,Y,Z,U):-
	X>Y, X>Z -> U is X;
	Y>X, Y>Z -> U is Y;
	Z>X, Z>Y -> U is Z.

fact_down(0, 1).
fact_down(N, X) :-
    N > 0,
    N1 is N - 1,
    fact_up(N1, X1), % Рекурсия
    X is N * X1.  % Умножаем N на результат рекурсии

fact_up(N, X) :- fact_up(N, 1, X).
fact_up(0, Acc, Acc).   % аккумулятор равен результату
fact_up(N, Acc, X) :-
    N > 0,
    N1 is N - 1,         % Уменьшаем N на 1
    Acc1 is Acc * N,     % Умножаем аккумулятор на N
    fact_up(N1, Acc1, X). % Рекурсивный вызов с обновленным аккумулятором

sum_digits_down(0, 0).  % Базовый случай, сумма цифр числа 0 равна 0
sum_digits_down(N, Sum) :-
    N > 0,
    Digit is N mod 10,      % Извлекаем последнюю цифру числа
    N1 is N // 10,          % Убираем последнюю цифру из числа
    sum_digits_down(N1, Rest),  % Рекурсивно вычисляем сумму оставшихся цифр
    Sum is Rest + Digit.     % Добавляем текущую цифру к результату

sum_digits_up(N, Sum) :- sum_digits_up(N, 0, Sum).

sum_digits_up(0, Acc, Acc).   % Базовый случай, когда число 0, сумма равна аккумулятору
sum_digits_up(N, Acc, Sum) :-
    N > 0,
    Digit is N mod 10,      % Извлекаем последнюю цифру числа
    N1 is N // 10,          % Убираем последнюю цифру из числа
    Acc1 is Acc + Digit,    % Добавляем цифру в аккумулятор
    sum_digits_up(N1, Acc1, Sum).  % Рекурсивно вызываем для оставшейся части числа

% Чтение списка с клавиатуры
read_list(List) :-
    write('vvedite spisok vot tak [1, 2, 3, ...]: '),  % Просим пользователя ввести список
    read(List).  % Считываем список с клавиатуры

% Вывод списка на экран
print_list([]) :-  % Базовый случай: пустой список не выводим
    nl.  % Просто переходим на новую строку
print_list([Head|Tail]) :-  % Для непустого списка
    write(Head),  % Печатаем голову списка
    write(' '),  % Добавляем пробел для разделения
    print_list(Tail).  % Рекурсивно печатаем хвост списка

% Базовый случай: если список пуст, сумма равна 0
sum_list_down([], 0).

% Рекурсивный случай: вычисляем сумму элементов списка
sum_list_down([Head|Tail], Summ) :-
    sum_list_down(Tail, Rest),  % Рекурсивно вычисляем сумму хвоста списка
    (   var(Summ)                     % Если сумма не передана, вычисляем ее
    ->  Summ is Head + Rest           % В противном случае, прибавляем голову к хвосту
    ;   Summ =:= Head + Rest          % Если сумма передана, проверяем ее равенство
    ).

% Главный предикат, который выполняет все действия
execute :-
    read_list(L),               % Читаем список
    print_list(L),              % Печатаем список
    sum_list_down(L, Summ),     % Считаем сумму
    write('summa elementov: '),  % Выводим сообщение
    write(Summ), nl.            % Выводим сумму

% Базовый случай: если список пуст, сумма равна 0
sum_list_up([], 0).

% Рекурсивный случай: вычисляем сумму элементов списка
sum_list_up([Head|Tail], Summ) :-
    sum_list_up(Tail, Rest),  % Рекурсивно вычисляем сумму хвоста списка
    Summ is Head + Rest.      % Добавляем голову списка к сумме хвоста

% Удаление элементов, сумма цифр которых равна заданному значению
remove_elements_with_sum_of_digits([], _, []).  % Базовый случай: пустой список, ничего не удаляем
remove_elements_with_sum_of_digits([Head|Tail], Sum, Result) :-
    sum_digits_up(Head, SumDigits),  % Вычисляем сумму цифр элемента
    (   SumDigits =:= Sum            % Если сумма цифр равна заданной
    ->  remove_elements_with_sum_of_digits(Tail, Sum, Result)  % Не добавляем этот элемент в результат
    ;   Result = [Head|Rest],        % Если сумма цифр не равна заданной, оставляем элемент
        remove_elements_with_sum_of_digits(Tail, Sum, Rest)  % Рекурсивный вызов для хвоста списка
    ).

% Главный предикат, который выполняет все действия
deleting :-
    read_list(L),               % Читаем список
    write('vvedite summu cifr dlya udaleniya: '),  % Запрашиваем сумму цифр
    read(Sum),                  % Считываем сумму
    remove_elements_with_sum_of_digits(L, Sum, Result),  % Удаляем элементы с данной суммой цифр
    write('obrabotanny spisok: '),  % Выводим обработанный список
    print_list(Result).         % Печатаем обработанный список