import XCTest

extension XCTestCase {
    func resourceURL(
        name: String,
        ext: String = "png",
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> URL {
        let bundle: Bundle = .module
        let url = bundle.url(forResource: name, withExtension: ext)
        
        return try XCTUnwrap(url, "for resource with name \"\(name).\(ext)\"", file: file, line: line)
    }
}
