@testable import FillHoleLib
import XCTest

final class PixelConnectivityTests: XCTestCase {
    func test_neighbours_4() {
        let pixelConnectivity: PixelConnectivity = .four
        
        let neighbours = pixelConnectivity.neighbours(of: .init(0, 0))
        
        let expectedNeighbours: [Point] = [
                     (-1, 0),
            (0, -1),          (0, 1),
                     ( 1, 0)
        ].map(Point.init)
        
        XCTAssertEqual(neighbours.count, expectedNeighbours.count)
        XCTAssertEqual(Set(neighbours), Set(expectedNeighbours))
    }
    
    func test_neighbours_8() {
        let pixelConnectivity: PixelConnectivity = .eight
        
        let neighbours = pixelConnectivity.neighbours(of: .init(0, 0))
        
        let expectedNeighbours: [Point] = [
            (-1, -1), (-1, 0), (-1, 1),
            ( 0, -1),          ( 0, 1),
            ( 1, -1), ( 1, 0), ( 1, 1),
        ].map(Point.init)
        
        XCTAssertEqual(neighbours.count, expectedNeighbours.count)
        XCTAssertEqual(Set(neighbours), Set(expectedNeighbours))
    }
}
