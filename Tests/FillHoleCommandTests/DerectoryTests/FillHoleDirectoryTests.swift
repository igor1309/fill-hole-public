@testable import FillHoleCommand
import XCTest

final class FillHoleDirectoryTests: XCTestCase {
    func test_outputURL_() async throws {
        let directory = DirectoryStub()
        let sut = makeSUT(directory: directory)
        
        let outputURL = sut.fileInCurrentDirectory(named: "output")
        
        XCTAssertEqual(outputURL, URL(string: "output")!)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(directory: Directory) -> Directory {
        DirectoryStub()
    }
    
    private struct DirectoryStub: Directory {
        func fileInCurrentDirectory(named name: String) -> URL {
            URL(string: name)!
        }
    }
    
    private func anyURL() -> URL {
        URL(string: "any-url")!
    }
}
