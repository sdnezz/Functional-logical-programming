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

[<EntryPoint>]
let main (args : string[]) = 
    let res = solve 1.0 4.0 1.0
    match res with 
     | None -> System.Console.WriteLine("Нет решений")
     | Linear(x) -> System.Console.WriteLine("Линейное уравнение, корень: {0}", x)
     | Quadratic(x1, x2) -> System.Console.WriteLine("Квадратное уравнение, корни: {0} {1}", x1, x2)
    0
