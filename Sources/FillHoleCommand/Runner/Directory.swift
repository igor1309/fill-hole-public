import Foundation

protocol Directory {
    func fileInCurrentDirectory(named name: String) -> URL
}
