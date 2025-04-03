// 1. Типы данных
type Author = { id: int; name: string }
type Book = { id: int; title: string; authorId: int }

// Пример данных
let authors = [
    { id = 1; name = "J.K. Rowling" }
    { id = 2; name = "George Orwell" }
]

let books = [
    { id = 1; title = "Harry Potter and the Philosopher's Stone"; authorId = 1 }
    { id = 2; title = "1984"; authorId = 2 }
]

// 2. Функции для получения данных
let getBookById (id: int) : Book option =
    books |> List.tryFind (fun b -> b.id = id)

let getAuthorById (id: int) : Author option =
    authors |> List.tryFind (fun a -> a.id = id)

// 3. Функция для вывода информации о книге и авторе
let printBookDetails (book: Book) (author: Author) =
    System.Console.WriteLine("Книга: {0}", book.title)
    System.Console.WriteLine("Автор: {0}", author.name)

// 4. Функтор для обработки данных
type BookFunctor() =
    static member map f book =
        match f book with
        | Some b -> b
        | None -> failwith "Не удалось найти книгу"

// 5. Конвейер для получения и вывода данных
let getBookAndPrintDetails (bookId: int) =
    let getBookDetails bookId =
        getBookById bookId
        |> Option.bind (fun book ->
            getAuthorById book.authorId
            |> Option.map (fun author -> (book, author)))
    
    BookFunctor.map getBookDetails bookId
    |> (fun (book, author) -> printBookDetails book author)

// 6. Тестирование
let testBookProcessing bookId =
    getBookAndPrintDetails bookId

[<EntryPoint>]
let main (args : string[]) = 
    // Пример: тестируем книгу с id = 1
    testBookProcessing 1

    // Пример: тестируем книгу с id = 2
    testBookProcessing 2

    0
