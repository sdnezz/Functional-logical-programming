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

let cyl_volume h r : float =
    h * circle_square r

let cur_cyl_volume h = 
    fun r -> cyl_volume h r

[<EntryPoint>]
let main (args : string[]) = 
    let res = solve 1.0 4.0 1.0
    match res with 
     | None -> System.Console.WriteLine("Нет решений")
     | Linear(x) -> System.Console.WriteLine("Линейное уравнение, корень: {0}", x)
     | Quadratic(x1, x2) -> System.Console.WriteLine("Квадратное уравнение, корни: {0} {1}", x1, x2)
    let r = 2.0
    let h = 5.0
    System.Console.WriteLine("Площадь круга: {0}", circle_square r)
    System.Console.WriteLine("Объем цилиндра: {0}", cyl_volume h r)
    let volumeFunc = cur_cyl_volume h
    System.Console.WriteLine("Объем цилиндра через каррирование: {0}", volumeFunc r)
    0
