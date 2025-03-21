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
    0
