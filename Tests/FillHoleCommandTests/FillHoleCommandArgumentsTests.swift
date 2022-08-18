@testable import FillHoleCommand
import XCTest

final class FillHoleCommandArgumentsTests: XCTestCase {
    func test_parse_failsOnEmptyArguments() {
        let arguments = [String]()
        assertError(forArguments: arguments, withMessage: "Missing expected argument '<source>'")
    }
    
    func test_parse_failsOnOneArgument() {
        let arguments = ["one"]
        assertError(forArguments: arguments, withMessage: "Missing expected argument '<mask>'")
    }
    
    func test_parse_failsOnTwoArguments() {
        let arguments = ["one", "two"]
        assertError(forArguments: arguments, withMessage: "Missing expected argument '<z>'")
    }
    
    func test_parse_failsOnThreeArgumentsWithBadZ() {
        let arguments = ["one", "two", "three"]
        assertError(forArguments: arguments, withMessage: "The value 'three' is invalid for '<z>'")
    }
    
    func test_parse_failsOnFourArgumentWithBadE() {
        let arguments = ["one", "two", "2", "four"]
        assertError(forArguments: arguments, withMessage: "The value 'four' is invalid for '<e>'")
    }
    
    func test_parse_failsOnFiveArgumentWithBadPixelConnectivity() {
        let arguments = ["one", "two", "2", "0.3", "five"]
        assertError(forArguments: arguments, withMessage: "The value 'five' is invalid for '<connectivity>': InitError()")
    }
    
    func test_parse_failsOnFiveArgumentOnIncorrectPixelConnectivity() {
        let arguments = ["one", "two", "2", "0.2", "1"]
        assertError(forArguments: arguments, withMessage: "The value '1' is invalid for '<connectivity>': InitError()")
    }
    
    func test_parse_fiveCorrectArguments_Connectivity4() throws {
        let arguments = ["one", "two", "2", "0.2", "4"]
        XCTAssertNoThrow(try FillHoleCommandArguments.parse(arguments))
        let sut = try FillHoleCommandArguments.parse(arguments)
        XCTAssertEqual(sut.connectivity, .four)
    }
    
    func test_parse_fiveCorrectArguments_Connectivity8() throws {
        let arguments = ["one", "two", "2", "0.2", "8"]
        XCTAssertNoThrow(try FillHoleCommandArguments.parse(arguments))
        let sut = try FillHoleCommandArguments.parse(arguments)
        XCTAssertEqual(sut.connectivity, .eight)
    }
    
    func test_parse_sixCorrectArguments_Connectivity4() throws {
        let arguments = ["one", "two", "2", "0.2", "4", "six"]
        XCTAssertNoThrow(try FillHoleCommandArguments.parse(arguments))
        let sut = try FillHoleCommandArguments.parse(arguments)
        XCTAssertEqual(sut.connectivity, .four)
    }
    
    func test_parse_sixCorrectArguments_Connectivity8() throws {
        let arguments = ["one", "two", "2", "0.2", "8", "six"]
        XCTAssertNoThrow(try FillHoleCommandArguments.parse(arguments))
        let sut = try FillHoleCommandArguments.parse(arguments)
        XCTAssertEqual(sut.connectivity, .eight)
    }
    
    func test_parse_setsDefaultOutputOnFiveArguments() throws {
        let arguments = ["one", "two", "2", "0.2", "4"]
        let sut = try FillHoleCommandArguments.parse(arguments)
        XCTAssertEqual(sut.outputFile, "output")
    }
    
    func test_parse_setsOutputOnSixArguments() throws {
        let arguments = ["one", "two", "2", "0.2", "4", "DDDDDDD"]
        let sut = try FillHoleCommandArguments.parse(arguments)
        XCTAssertEqual(sut.outputFile, "DDDDDDD")
    }
    
    // MARK: - Helpers
    
    private func assertError(
        forArguments arguments: [String],
        withMessage expectedMessage: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(
            try FillHoleCommandArguments.parse(arguments), file: file, line: line
        ) { error in
            let message = FillHoleCommandArguments.message(for: error)
            XCTAssertEqual(message, expectedMessage, file: file, line: line)
        }
    }
}

