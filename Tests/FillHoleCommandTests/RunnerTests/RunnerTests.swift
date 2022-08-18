@testable import FillHoleCommand
import UniformTypeIdentifiers
import XCTest

final class RunnerTests: XCTestCase {
    func test_run() throws {
        let (runner, arguments) = try makeSUT()
        
        try runner.run(with: arguments)
    }
    
    func test_run_throwsOnLoadError() throws {
        let (runner, arguments) = try makeSUT(loadResult: .failure(anyError(string: "load error")))
        
        XCTAssertThrowsError(
            try runner.run(with: arguments)
        ) { error in
            XCTAssertEqual((error as? AnyError)?.message, "load error")
        }
    }
    
    func test_run_throwsOnSaveError() throws {
        let (runner, arguments) = try makeSUT(saveResult: .failure(anyError(string: "save error")))
        
        XCTAssertThrowsError(
            try runner.run(with: arguments)
        ) { error in
            XCTAssertEqual((error as? AnyError)?.message, "save error")
        }
    }
    
    func test_run_throwsOnFillError() throws {
        let (runner, arguments) = try makeSUT(fillResult: .failure(anyError(string: "fill error")))
        
        XCTAssertThrowsError(
            try runner.run(with: arguments)
        ) { error in
            XCTAssertEqual((error as? AnyError)?.message, "fill error")
        }
    }
    
    func test_outputURL_trimsWhitespaces() throws {
        let args = ["one", "two", "2", "0.2", "4", " six "]
        let (runner, arguments) = try makeSUT(args: args)
        
        let outputURL = runner.outputURL(forFilename: arguments.outputFile)
        let filename = outputURL.lastPathComponent
        
        XCTAssertEqual(filename, "six.png")
    }
    
    func test_outputURL_png() throws {
        let (runner, arguments) = try makeSUT()
        
        let outputURL = runner.outputURL(forFilename: arguments.outputFile)
        let filename = outputURL.lastPathComponent
        
        XCTAssertEqual(filename, "six.png")
    }
    
    func test_outputURL_jpg() throws {
        let (runner, arguments) = try makeSUT(utType: .jpeg)
        
        let outputURL = runner.outputURL(forFilename: arguments.outputFile)
        let filename = outputURL.lastPathComponent
        
        XCTAssertEqual(filename, "six.jpeg")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        args: [String] = ["one", "two", "2", "0.2", "4", "six"],
        loadResult: LoadResult = .success(anyData()),
        saveResult: SaveResult = .success(()),
        fillResult: FileDataResult = .success(anyData()),
        utType: UTType = .png
    ) throws -> (
        runner: Runner,
        arguments: FillHoleCommandArguments
    ) {
        let directory: Directory = DirectoryStub()
        let fileIO: FileIO = FileIOStub(
            loadResult: loadResult,
            saveResult: saveResult
        )
        let filler: Filler = FillerStub(fillData: fillResult)
        
        let runner = Runner(
            directory: directory,
            fileIO: fileIO,
            holeFiller: filler,
            utType: utType
        )
        
        let arguments = try FillHoleCommandArguments.parse(args)
        
        return (runner, arguments)
    }
    
    private struct DirectoryStub: Directory {
        func fileInCurrentDirectory(named name: String) -> URL {
            URL(string: name)!
        }
    }
    
    typealias LoadResult = Result<FileData, Error>
    typealias SaveResult = Result<(), Error>
    typealias FileDataResult = Result<FileData, Error>
    
    private struct FileIOStub: FileIO {
        private let loadResult: LoadResult
        private let saveResult: SaveResult
        
        init(loadResult: LoadResult, saveResult: SaveResult) {
            self.loadResult = loadResult
            self.saveResult = saveResult
        }
        
        func load(from url: URL) throws -> FileData {
            try loadResult.get()
        }
        
        func save(_ fillData: FileData, to url: URL, utType: UTType) throws {
            try saveResult.get()
        }
    }
    
    private struct FillerStub: Filler {
        private let fillData: FileDataResult
        
        init(fillData: FileDataResult) {
            self.fillData = fillData
        }
        
        func fillHole(_ hole: FileData, in image: FileData) throws -> FileData {
            try fillData.get()
        }
    }
}

private func anyData(
    pixels: [UInt8] = [2, 4, 6, 8, 10, 12],
    width: Int = 3
) -> FileData {
    (pixels: pixels, width: width)
}
