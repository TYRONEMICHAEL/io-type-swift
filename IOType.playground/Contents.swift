import Foundation

func compose<A, B, C>(_ lhs: @escaping (A) -> B, _ rhs: @escaping (B) -> C) -> (A) -> C {
    return { a in
        return rhs(lhs(a))
    }
}

func compose<A, B>(_ lhs: @escaping (A) -> B, _ rhs: @escaping () -> A) -> () -> B {
    return {
        return lhs(rhs())
    }
}

struct IO<A> {

    private let value: () -> A

    init(value: @escaping () -> A) {
        self.value = value
    }

    func map<B>(_ fn: @escaping (A) -> B) -> IO<B> {
        return IO<B>(value: compose(fn, value))
    }

    func execute() -> A {
        return value()
    }

}

func getValueFromStorage(withId id: Int) -> () -> String? {
    return {
        return storage[id]
    }
}

let storage = [1: "Tyrone Michael Avnit"]
let uppercased: (String?) -> String? = { x in x?.uppercased() }
let uniqueName: (String?) -> String? = { x in x?.replacingOccurrences(of: " ", with: " | ") }

let io = IO(value: getValueFromStorage(withId: 1))
    .map(uppercased)
    .map(uniqueName)

let username = io.execute()
print(username)

