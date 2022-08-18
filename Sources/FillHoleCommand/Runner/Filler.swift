protocol Filler {
    func fillHole(
        _ hole: FileData,
        in image: FileData
    ) throws -> FileData
}
