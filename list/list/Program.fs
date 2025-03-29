open System

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

let rec readChurchList n =
    if n = 0 then
        fun f x -> x
    else
        let a = int (Console.ReadLine())
        let t = readChurchList (n - 1)
        fun f x -> f a (t f x)

let toList cl =
    cl (fun a acc -> a :: acc) []

[<EntryPoint>]
let main args =
    let list1 = [2;3;4]
    let list2 = 100::list1
    System.Console.WriteLine(list2)
    let list3 = list1 @ list2
    System.Console.WriteLine("длина списка {0}:", list2.Length)
    System.Console.WriteLine("голова списка {0}:", list2.Head)
    System.Console.WriteLine("хвост списка {0}:", list2.Tail)
    System.Console.WriteLine("голова хвоста {0}:", list2.Tail.Head)
    System.Console.WriteLine("голова хвоста хвоста {0}:", list2.Tail.Tail.Head)
    System.Console.WriteLine("длина листа замержиного {0}:", list3.Length)
    System.Console.WriteLine("вывод отдельного элемента {0}:", list2.Item(3))
    System.Console.WriteLine("вывод отдельного элемента {0}:", List.sort[1;4;6;-2;5])
    System.Console.WriteLine("вывод отдельного элемента {0}:", List.sortBy(fun elem -> -1*elem)[1;4;6;-2;5])
    System.Console.WriteLine("вывод отдельного элемента {0}:", List.find(isEven)[-1;-3;2;4])

    //6
    System.Console.WriteLine("Введите количество элементов списка Чёрча:")
    let n = int (Console.ReadLine())
    System.Console.WriteLine("Введите {0} элементов списка Чёрча: ", n)
    let chlist = readChurchList n
    let lst = List.rev (toList chlist)
    System.Console.WriteLine("Получившийся список:  {0}", (lst |> List.map string |> String.concat "; "))
    0