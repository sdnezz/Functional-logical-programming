open System

// Список простых чисел (int64)
let primes = [2L; 3L; 5L; 7L; 11L; 13L]

// Фиксированные показатели для начала
let exponents = [2; 2; 1; 1; 1; 1]

// Вычисление n
let n = 
    List.zip primes exponents
    |> List.map (fun (p, e) -> pown p e)
    |> List.fold (*) 1L

printfn "Минимальное n: %d" (int n)