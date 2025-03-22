open System
type SolveResult = 
    | None
    | Linear of float
    | Quadratic of float * float

let solve a b c =
    let D = b*b - 4.0*a*c
    if a = 0.0 then
        if b = 0.0 then None
        else Linear(-c/b)
    elif D = 0.0 then
        Linear(-b / (2.0*a))
    else 
        if D < 0.0 then None
        else Quadratic(((-b + sqrt D) / (2.0*a)),(-b - sqrt D) / (2.0*a))

let circle_square r : float =
    let pi = 3.14159
    pi * r * r

let volume h s : float =
    h * s

let cyl_volume_curry h =
    fun s -> volume h s

let cyl_volume_superposition h =
    (circle_square) >> volume h

let rec cifrSum n = 
    if n = 0 then 0
    else (n%10) + (cifrSum (n/10))

let sumCifr n =
    let rec sumCifr1 n curSum = 
        if n = 0 then curSum
        else
            let n1 = n / 10
            let cifr = n % 10
            let newSum = curSum + cifr
            sumCifr1 n1 newSum
    sumCifr1 n 0

let rec factorial1 n = 
    if n <=1 then 1 else n*factorial1 (n-1)

let rec factorial n =
    let rec fact1 n acc =
        if n=1 then acc
        else 
            fact1 (n-1) (n*acc)
    fact1 n 1

let chose_case (arg: bool)= 
    match arg with
     | true -> sumCifr
     | false -> factorial

let rec number_traversal (n: int) (f: int -> int -> int) (init: int) : int =
    let rec traverse n acc =
        match n with
        | 0 -> acc
        | _ ->
            let digit = n % 10
            let newAcc = f acc digit
            traverse (n / 10) newAcc
    traverse n init

let rec number_traversal_bool (n: int) (f: int -> int -> int) (init: int) (p: int-> bool): int =
    let rec traverse n acc =
        match n with
        | 0 -> acc
        | _ ->
            let digit = n % 10
            let newAcc = if p digit then f acc digit else acc
            traverse (n / 10) newAcc
    traverse n init

[<EntryPoint>]
let main (args : string[]) = 
    let res = solve 1.0 4.0 1.0
    match res with 
     | None -> System.Console.WriteLine("Нет решений")
     | Linear(x) -> System.Console.WriteLine("Линейное уравнение, корень: {0}", x)
     | Quadratic(x1, x2) -> System.Console.WriteLine("Квадратное уравнение, корни: {0} {1}", x1, x2)
    let r = 2.0
    let h = 5.0
    let s = circle_square r
    System.Console.WriteLine("Площадь круга: {0}", s)
    let volumeFunc = cyl_volume_curry h
    System.Console.WriteLine("Объем цилиндра через каррирование: {0}", volumeFunc s)
    System.Console.WriteLine("Объем цилиндра через оператор суперпозиции: {0}", cyl_volume_superposition h r)
    System.Console.WriteLine("Объем цилиндра через конвеер: {0}", s |> volume h)
    System.Console.WriteLine("сумма цифр рекурсией вверх: {0}", cifrSum 123)
    System.Console.WriteLine("сумма цифр рекурсией вниз: {0}", sumCifr 123)
    System.Console.WriteLine("Факториал числа вверх: {0}", factorial1 3)
    System.Console.WriteLine("Факториал числа вниз: {0}", factorial 3)
    System.Console.WriteLine("Логическая функция (вызываем сумму цифр): {0}", chose_case true 123)
    System.Console.WriteLine("Логическая функция (факториал): {0}", chose_case false 5)
    System.Console.WriteLine("Сумма цифр через общий обход: {0} ", number_traversal 123 (+) 0 )
    System.Console.WriteLine("Произведение цифр через общий обход: {0} ", number_traversal 123 (*) 1 )
    System.Console.WriteLine("Максимальная цифра через общий обход: {0} ", number_traversal 123 (max) 0 )
    System.Console.WriteLine("Минимальная цифра через общий обход: {0} ", number_traversal 123 (min) 1000 )
    System.Console.WriteLine("Общий обход с лямбда - сумма: {0} ", number_traversal 123 (fun acc digit -> acc + digit) 0 )
    System.Console.WriteLine("Общий обход с лямбда - умножение: {0} ", number_traversal 123 (fun acc digit -> acc * digit) 1 )
    System.Console.WriteLine("Общий обход с лямбда - максимум: {0} ", number_traversal 123 (fun acc digit -> max acc digit) 0 )
    System.Console.WriteLine("Общий обход с лямбда - минимум: {0} ", number_traversal 123 (fun acc digit -> min acc digit) 1000 )
    let isEven digit = digit % 2 = 0
    let notEven digit = digit % 2 <> 0
    let isPrime number = 
        if number < 2 then false
        else 
            let rec check divisor =
                if divisor * divisor > number then true
                elif number % divisor = 0 then false
                else check (divisor + 1)
            check 2

    System.Console.WriteLine("Обход числа с условием - сумма четных: {0} ", number_traversal_bool 123 (+) 0 isEven)
    System.Console.WriteLine("Обход числа с условием - пр-ие нечетных: {0} ", number_traversal_bool 123 (*) 1 notEven)
    System.Console.WriteLine("Обход числа с условием - максимум четных: {0} ", number_traversal_bool 123 (max) 0 isEven)
    System.Console.WriteLine("Обход числа с условием - минимум нечетных: {0} ", number_traversal_bool 123 (min) 1000 notEven)
    System.Console.WriteLine("1) Обход числа - количество четных: {0} ", number_traversal_bool 123 (fun acc digit -> acc + 1) 0 isEven)
    System.Console.WriteLine("2) Обход числа - сумма цифр, больших 3: {0} ", number_traversal_bool 123 (+) 0 (fun digit -> digit > 3))
    System.Console.WriteLine("3) Обход числа - максимальная простая цифра: {0} ", number_traversal_bool 1759 (max) 0 isPrime)
    0