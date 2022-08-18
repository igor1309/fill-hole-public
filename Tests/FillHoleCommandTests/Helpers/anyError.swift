func anyError(string: String = "any-error") -> Error {
    AnyError(message: string)
}

struct AnyError: Error {
    let message: String
}
