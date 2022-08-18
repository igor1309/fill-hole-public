import Foundation

protocol Loader {
    func load(from url: URL) throws -> FileData
}
