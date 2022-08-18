import XCTest

extension XCTestCase {
    func assertThrowsError<T, E: Error & Equatable>(
        _ expression: @autoclosure () throws -> T,
        _ expectedError: E,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try expression(), message(), file: file, line: line) { assertError(error: $0, is: expectedError, file: file, line: line) }
    }
    
    func assertError<E: Error & Equatable>(
        error: Error,
        is expectedError: E,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(error as? E, expectedError, message(), file: file, line: line)
    }
}
