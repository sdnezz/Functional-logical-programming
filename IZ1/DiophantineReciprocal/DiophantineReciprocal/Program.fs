open System

// Список простых чисел (int64)
let primes = [2L; 3L; 5L; 7L; 11L; 13L]

// Целевое значение для d(n^2)
let target = 1999

// Функция для вычисления d(n^2) по списку показателей
let d_n2 exponents =
    exponents
    |> List.map (fun e -> 2 * e + 1)
    |> List.fold (*) 1

// Фиксированные показатели для начала
let exponents = [2; 2; 1; 1; 1; 1]

// Вычисление n и проверка
let n = 
    List.zip primes exponents
    |> List.map (fun (p, e) -> pown p e)
    |> List.fold (*) 1L

// Вычисление d(n^2) и количества решений
let divisors = d_n2 exponents
let solutions = (divisors + 1) / 2

printfn "Минимальное n: %d" (int n)
printfn "d(n^2): %d" divisors
printfn "Количество решений: %d" solutions