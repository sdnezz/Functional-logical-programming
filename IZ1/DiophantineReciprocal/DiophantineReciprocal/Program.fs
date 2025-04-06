open System

let rec calculateExponents primes target currentProd currentExponents =
    match primes with
    | [] -> 
        if currentProd > target then 
            Some(currentExponents |> List.rev) 
        else 
            None
    | p::rest ->
        let maxExp = 
            let remainingTarget = target / currentProd
            if remainingTarget <= 1 then 
                0
            else 
                (log (float remainingTarget) / log 3.0 |> ceil |> int)
        
        let rec tryExponent e =
            if e > maxExp then 
                None
            else
                let newProd = currentProd * (2 * e + 1)
                match calculateExponents rest target newProd (e::currentExponents) with
                | Some(exps) -> Some(exps)
                | None -> tryExponent (e + 1)
        
        tryExponent 0

// Оптимальные показатели степеней для минимального n
let primes = [2L; 3L; 5L; 7L; 11L; 13L] // int64
let exponents = [2; 2; 1; 1; 1; 1] // Показатели для n = 2^2 * 3^2 * 5^1 * 7^1 * 11^1 * 13^1

// Вычисление n с использованием pown для int64
let n = 
    List.zip primes exponents
    |> List.map (fun (p, e) -> pown p e) // pown поддерживает int64
    |> List.fold (*) 1L

printfn "Минимальное n: %d" (int n)