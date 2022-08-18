@testable  import FillHoleCommand
import UniformTypeIdentifiers
import XCTest

final class FileIOTests: XCTestCase {
    func test_load_failsOnLoaderFailure() throws {
        let loader = makeSUT(loadResult: .failure(anyError())).loader
        
        XCTAssertThrowsError(try loader.load(from: anyURL()))
    }
    
    func test_load_successfullyLoadsFileData() throws {
        let fileData = anyFileData()
        let loader = makeSUT(loadResult: .success(fileData)).loader
        
        let grayscale = try loader.load(from: anyURL())
        
        XCTAssertEqual(grayscale.pixels, fileData.pixels)
        XCTAssertEqual(grayscale.width, fileData.width)
    }
    
    func test_save_failsOnSaverFailure() throws {
        let saver = makeSUT(saveResult: .failure(anyError())).saver
        
        XCTAssertThrowsError(try saver.save(anyFileData(), to: anyURL()))
    }
    
    func test_save_successfullySavesFileData() throws {
        let saver = makeSUT(saveResult: .success(())).saver
        
        XCTAssertNoThrow(try saver.save(anyFileData(), to: anyURL()))
    }
    
    // MARK: - Helpers
    
    typealias LoadResult = Result<FileData, Error>
    typealias SaveResult = Result<Void, Error>
    
    private func makeSUT(
        loadResult: LoadResult = .success(anyFileData()),
        saveResult: SaveResult = .success(())
    ) -> (loader: Loader, saver: Saver) {
        let loader = LoaderStub(result: loadResult)
        let saver = SaverStub(result: saveResult)
        
        return (loader, saver)
    }
    
    private struct LoaderStub: Loader {
        private let result: LoadResult
        
        init(result: LoadResult) {
            self.result = result
        }
        
        func load(from url: URL) throws -> FileData {
            try result.get()
        }
    }
    
    private struct SaverStub: Saver {
        private let result: SaveResult
        
        init(result: SaveResult) {
            self.result = result
        }
        
        func save(_ fileData: FileData, to url: URL, utType: UTType) throws {
            _ = try result.get()
        }
    }
}

private func anyFileData(
    pixels: [UInt8] = [2, 4, 6],
    width: Int = 3
) -> FileData {
    return (pixels: pixels, width: width)
}

private func anyURL(string: String = "any-url") -> URL {
    .init(string: string)!
}

private extension Saver {
    func save(_ fileData: FileData, to url: URL) throws {
        try save(fileData, to: url, utType: .png)
    }
}
