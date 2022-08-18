@testable import FillHoleCommand
import Foundation
import XCTest

final class FillHoleValidatorTests: XCTestCase {
    func test_makeArguments() throws {
        let arguments = try makeArguments()
        
        XCTAssertEqual(arguments.source.path, fileURLPath("source"))
        XCTAssertEqual(arguments.mask.path, fileURLPath("mask"))
        XCTAssertEqual(arguments.z, 2)
        XCTAssertEqual(arguments.e, 0.01)
        XCTAssertEqual(arguments.connectivity, .four)
        XCTAssertEqual(arguments.outputFile, "output")
    }
    
    func test_validate_validatesValidArguments() throws {
        let fileSystem = makeFileSystem()
        let sut = makeSUT(fileSystem: fileSystem)
        
        let arguments = try makeArguments()
        
        try sut.validate(arguments: arguments)
    }
    
    func test_validate_failsOnBadSource() throws {
        let fileSystem = makeFileSystem([.source: false, .mask: true])
        let sut = makeSUT(fileSystem: fileSystem)
        
        let arguments = try makeArguments()
        
        throwsError(
            try sut.validate(arguments: arguments),
            .noFile(.source, at: fileURLPath("source"))
        )
    }
    
    func test_validate_failsOnBadMask() throws {
        let fileSystem = makeFileSystem([.source: true, .mask: false])
        let sut = makeSUT(fileSystem: fileSystem)
        
        let arguments = try makeArguments()
        
        throwsError(
            try sut.validate(arguments: arguments),
            .noFile(.mask, at: fileURLPath("mask"))
        )
    }
    
    func test_validate_failsOnBadOutputFile() throws {
        let fileSystem = makeFileSystem()
        let sut = makeSUT(fileSystem: fileSystem)
        
        let outputFile = " \n\n"
        let arguments = try makeArguments(outputFile: outputFile)
        
        throwsError(
            try sut.validate(arguments: arguments),
            .badOutput(outputFile)
        )
    }
    
    func test_validate_failsOnBadParameterE() throws {
        let fileSystem = makeFileSystem()
        let sut = makeSUT(fileSystem: fileSystem)
        
        let e = 1.01
        let arguments = try makeArguments(e: e)
        
        throwsError(
            try sut.validate(arguments: arguments),
            .tooBigE(e)
        )
    }
    
    func test_ValidationErrorDescription() {
        var error: ValidationError
        
        error = .noFile(.source, at: "source")
        XCTAssertEqual(
            error.errorDescription,
            "There is no source file at \"source\"."
        )
        
        error = .noFile(.mask, at: "mask")
        XCTAssertEqual(
            error.errorDescription,
            "There is no mask file at \"mask\"."
        )
        
        error = .badOutput("\n\n\n")
        XCTAssertEqual(
            error.errorDescription,
            "Bad output filename \"\n\n\n\""
        )
        
        error = .tooBigE(1.1)
        XCTAssertEqual(
            error.errorDescription,
            "Parameter `e` is too big (\(1.1))."
        )
    }
    
    // MARK: - Helpers
    
    typealias ValidationError = Validator.ValidationError
    
    private func throwsError<T>(
        _ expression: @autoclosure () throws -> T,
        _ expectedError: ValidationError,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assertThrowsError(try expression(), expectedError, message(), file: file, line: line)
    }
    
    private func makeArguments(
        source: String = "source",
        mask: String = "mask",
        z: Int = 2,
        e: Double = 0.01,
        connectivity: Connectivity = .four,
        outputFile: String = "output",
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> FillHoleCommandArguments {
        let zString: String = String(z)
        let eString: String = String(e)
        let connectivityString: String = String(connectivity.rawValue)
        
        let arguments: [String] = [
            source,
            mask,
            zString,
            eString,
            connectivityString,
            outputFile
        ]
        
        return try FillHoleCommandArguments.parse(arguments)
    }
    
    private func makeSUT(fileSystem: FileSystem) -> Validator {
        .init(fileSystem: fileSystem)
    }
    
    private func makeFileSystem(_ files: [Validator.Kind : Bool] = [.source: true, .mask: true]) -> FileSystemStub {
        .init(files: files)
    }
    
    private struct FileSystemStub: FileSystem {
        private let files: [String: Bool]
        
        init(files: [Validator.Kind : Bool]) {
            self.files = files.reduce(into: [String: Bool]()) { partialResult, val in
                partialResult[fileURLPath(val.key.rawValue)] = val.value
            }
        }
        
        func fileExists(atPath path: String) -> Bool {
            files[path] ?? false
        }
    }
}

private func fileURLPath(_ filename: String) -> String {
    URL(fileURLWithPath: filename).path
}
