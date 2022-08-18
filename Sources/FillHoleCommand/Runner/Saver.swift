import Foundation
import UniformTypeIdentifiers

protocol Saver {
    func save(_ fileData: FileData, to url: URL, utType: UTType) throws
}
