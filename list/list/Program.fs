open System
[<EntryPoint>]
let main args =
    let list1 = [2;3;4]
    let list2 = 100::list1
    System.Console.WriteLine(list2)
    let list3 = list1 @ list2
    System.Console.WriteLine("{0}", list2.Length)
    System.Console.WriteLine("{0}", list2.Head)
    System.Console.WriteLine("{0}", list2.Tail)
    System.Console.WriteLine("{0}", list2.Tail.Head)
    System.Console.WriteLine("{0}", list2.Tail.Tail.Head)
    System.Console.WriteLine("{0}", list2.Tail.Tail.Head)
    0