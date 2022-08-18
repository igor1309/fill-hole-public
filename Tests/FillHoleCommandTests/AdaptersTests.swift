@testable import FillHoleCommand
import XCTest
import FillHoleLib

final class AdaptersTests: XCTestCase {
    func test_chunked() throws {
        let array = [1, 2, 3, 4, 5]
        
        let chunked = array.chunked(into: 2)
        
        XCTAssertEqual(chunked, [[1, 2], [3, 4], [5]])
    }
    
    func test_image_extraProperties() throws {
        let pixels: [UInt8] = [1, 2, 3, 4, 5, 6]
        let width = 3
        
        let image = Image(pixels: pixels, width: width)
        
        XCTAssertEqual(image.values, [
            [1.0 / 255, 2.0 / 255, 3.0 / 255],
            [4.0 / 255, 5.0 / 255, 6.0 / 255]
        ])
        XCTAssertEqual(image.width, width)
        XCTAssertEqual(image.fileData.pixels, pixels)
        XCTAssertEqual(image.fileData.width, width)
    }
    
    func test_connectivity() {
        let c4: Connectivity = .four
        XCTAssertEqual(c4.pixelConnectivity, .four)

        let c8: Connectivity = .eight
        XCTAssertEqual(c8.pixelConnectivity, .eight)
    }
}
