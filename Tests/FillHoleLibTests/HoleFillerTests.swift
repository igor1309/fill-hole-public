@testable import FillHoleLib
import XCTest

final class HoleFillerTests: XCTestCase {
    func test_findBH_empty_withPixelConnectivity4() {
        let filler = makeSUT(pixelConnectivity: .four)
        let mask: Image = .init(matrix: [[]])
        
        let boundary = filler.findBoundaryAndHole(hole: mask).boundary
        
        XCTAssertEqual(boundary, [])
    }
    
    func test_findBH_oneHole_withPixelConnectivity4() {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [[0]])
        
        let (boundary, hole) = filler.findBoundaryAndHole(hole: image)

        XCTAssertEqual(boundary, [])
        XCTAssertEqual(hole, [.init(0, 0)])
    }
    
    func test_findBH_one_withPixelConnectivity4() {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [[1]])
        
        let (boundary, hole) = filler.findBoundaryAndHole(hole: image)

        XCTAssertEqual(boundary, [])
        XCTAssertEqual(hole, [])
    }
    
    func test_findBH_3x3_withPixelConnectivity4() throws {
        let source = """
            -  -  -
            -  0  -
            -  -  -
            """
        let result = """
            -  b  -
            b  0  b
            -  b  -
            """
        try assertFindBH(source: source, result: result, .four)
    }
    
    func test_findBH_4x4_withPixelConnectivity4() throws {
        let source = """
            -  -  -  -
            -  0  -  -
            -  -  -  -
            -  -  -  -
            """
        let result = """
            -  b  -  -
            b  0  b  -
            -  b  -  -
            -  -  -  -
            """

        try assertFindBH(source: source, result: result, .four)
    }
    
    func test_findBH_4x4a_withPixelConnectivity4() throws {
        let source = """
            -  -  -  -
            -  0  0  -
            -  -  0  -
            -  -  -  -
            """
        let result = """
            -  b  b  -
            b  0  0  b
            -  b  0  b
            -  -  b  -
            """

        try assertFindBH(source: source, result: result, .four)
    }
    
    func test_findBH_4x5_withPixelConnectivity4() throws {
        let source = """
            -  -  -  -  -
            -  0  0  0  -
            -  -  0  -  -
            -  -  -  -  -
            """
        let result = """
            -  b  b  b  -
            b  0  0  0  b
            -  b  0  b  -
            -  -  b  -  -
            """

        try assertFindBH(source: source, result: result, .four)
    }
    
    func test_findBH_withPixelConnectivity4() throws {
        let source = """
        -  -  -  -  -  -  -  -
        -  -  0  -  -  -  -  -
        -  -  0  0  0  0  -  -
        -  -  -  0  0  -  -  -
        -  -  -  -  -  -  -  -
        """
        let result = """
        -  -  b  -  -  -  -  -
        -  b  0  b  b  b  -  -
        -  b  0  0  0  0  b  -
        -  -  b  0  0  b  -  -
        -  -  -  b  b  -  -  -
        """

        try assertFindBH(source: source, result: result, .four)
    }
    
    func test_findBH_empty_withPixelConnectivity8() {
        let filler = makeSUT(pixelConnectivity: .eight)
        let mask: Image = .init(matrix: [[]])
        
        let boundary = filler.findBoundaryAndHole(hole: mask).boundary
        
        XCTAssertEqual(boundary, [])
    }
    
    func test_findBH_one_withPixelConnectivity8() {
        let filler = makeSUT(pixelConnectivity: .eight)
        let mask: Image = .init(matrix: [[0]])
        
        let boundary = filler.findBoundaryAndHole(hole: mask).boundary
        
        XCTAssertEqual(boundary, [])
    }
    
    func test_findBH_3x3_withPixelConnectivity8() throws {
        let source = """
            -  -  -
            -  0  -
            -  -  -
            """
        let result = """
            b  b  b
            b  0  b
            b  b  b
            """
        try assertFindBH(source: source, result: result, .eight)
    }
    
    func test_findBH_4x4_withPixelConnectivity8() throws {
        let source = """
            -  -  -  -
            -  0  -  -
            -  -  -  -
            -  -  -  -
            """
        let result = """
            b  b  b  -
            b  0  b  -
            b  b  b  -
            -  -  -  -
            """

        try assertFindBH(source: source, result: result, .eight)
    }
    
    func test_findBH_4x4a_withPixelConnectivity8() throws {
        let source = """
            -  -  -  -
            -  0  0  -
            -  -  0  -
            -  -  -  -
            """
        let result = """
            b  b  b  b
            b  0  0  b
            b  b  0  b
            -  b  b  b
            """

        try assertFindBH(source: source, result: result, .eight)
    }
    
    func test_findBH_4x5_withPixelConnectivity8() throws {
        let source = """
            -  -  -  -  -
            -  0  0  0  -
            -  -  0  -  -
            -  -  -  -  -
            """
        let result = """
            b  b  b  b  b
            b  0  0  0  b
            b  b  0  b  b
            -  b  b  b  -
            """

        try assertFindBH(source: source, result: result, .eight)
    }
    
    func test_findBH_withPixelConnectivity8() throws {
        let source = """
        -  -  -  -  -  -  -  -
        -  -  0  -  -  -  -  -
        -  -  0  0  0  0  -  -
        -  -  -  0  0  -  -  -
        -  -  -  -  -  -  -  -
        """
        let result = """
        -  b  b  b  -  -  -  -
        -  b  0  b  b  b  b  -
        -  b  0  0  0  0  b  -
        -  b  b  0  0  b  b  -
        -  -  b  b  b  b  -  -
        """

        try assertFindBH(source: source, result: result, .eight)
    }
    
    func test_fill_failsOnEmptyImage_4() throws {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [[]])
        let hole = Image(matrix: [[]])
        
        XCTAssertThrowsError(try filler.fill(hole, in: image)) { error in
            XCTAssertNotNil(error as? HoleFiller.EmptyImageError)
        }
    }
    
    func test_fill_failsOnImageOfOne_4() throws {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [[1]])
        let hole = Image(matrix: [[0]])
        
        XCTAssertThrowsError(try filler.fill(hole, in: image)) { error in
            XCTAssertNotNil(error as? HoleFiller.ImageIsTooSmallError)
        }
    }
    
    func test_fill_failsOnEmptyImage_8() throws {
        let filler = makeSUT(pixelConnectivity: .eight)
        let image = Image(matrix: [[]])
        let hole = Image(matrix: [[]])
        
        XCTAssertThrowsError(try filler.fill(hole, in: image)) { error in
            XCTAssertNotNil(error as? HoleFiller.EmptyImageError)
        }
    }
    
    func test_fill_pixelConnectivity4_fails_onEmpty() throws {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [[]])
        let hole = try Image.make(from: """
            -  -  -
            -  0  -
            -  -  -
            """)

        XCTAssertThrowsError(try filler.fill(hole, in: image)) { error in
            XCTAssertNotNil(error as? HoleFiller.EmptyImageError)
        }
    }

    func test_fill_pixelConnectivity4_fails_onSmall() throws {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [[1], [2]])
        let hole = try Image.make(from: """
            -  -  -
            -  0  -
            -  -  -
            """)

        XCTAssertThrowsError(try filler.fill(hole, in: image)) { error in
            XCTAssertNotNil(error as? HoleFiller.ImageIsTooSmallError)
        }
    }

    func test_fill_pixelConnectivity4_fails_onDifferent() throws {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [
            [0.125, 0.5, 0.625],
            [0.5,   0.5, 0.5],
            [0.5,   0.5, 0.5],
            [0.5,   0.5, 0.5],
        ])
        let hole = try Image.make(from: """
            -  -  -
            -  0  -
            -  -  -
            """)

        XCTAssertThrowsError(try filler.fill(hole, in: image)) { error in
            XCTAssertNotNil(error as? HoleFiller.DifferentDimensionsError)
        }
    }

    func test_fill_pixelConnectivity4() throws {
        let filler = makeSUT(pixelConnectivity: .four)
        let image = Image(matrix: [
            [0.125, 0.5, 0.625],
            [0.125, 0.5, 0.5],
            [0.5,   0.5, 0.5],
        ])
        let hole = try Image.make(from: """
            -  -  -
            -  0  -
            -  -  -
            """)

        let result = try filler.fill(hole, in: image)

        let c = (0.5 + 0.125 + 0.5 + 0.5)/4.0
        XCTAssertEqual(c, 0.40625)
        XCTAssertEqual(
            try XCTUnwrap(result[.init(1, 1)]),
            c, accuracy: 0.00001)
        assertEqual(
            result.values,
            [
                [0.125, 0.5, 0.625],
                [0.125, c,   0.5],
                [0.5,   0.5, 0.5],
            ], accuracy: 0.00001
        )
    }

    func test_fill_pixelConnectivity8() throws {
        let filler = makeSUT(pixelConnectivity: .eight, balance: .init { _,_ in 1 })
        let matrix = [
            [0.125, 0.5, 0.625],
            [0.125, 0.5, 0.5],
            [0.5,   0.5, 0.5],
        ]
        let image = Image(matrix: matrix)
        let hole = try Image.make(from: """
            -  -  -
            -  0  -
            -  -  -
            """)

        let result = try filler.fill(hole, in: image)

        let sum = matrix.reduce([], +).reduce(0, +)
        let c = (sum - 0.5)/8.0
        XCTAssertEqual(c, 0.421875)
        XCTAssertEqual(
            try XCTUnwrap(result[.init(1, 1)]),
            c, accuracy: 0.00001)
        assertEqual(
            result.values,
            [
                [0.125, 0.5, 0.625],
                [0.125, c,   0.5],
                [0.5,   0.5, 0.5],
            ], accuracy: 0.00001
        )
    }

    // MARK: - Helpers
    
    private func makeSUT(
        pixelConnectivity: PixelConnectivity,
        balance: Balance = .default()
    ) -> HoleFiller {
        .init(
            pixelConnectivity: pixelConnectivity,
            balance: balance
        )
    }
    
    private func assertEqual(
        _ lhs: [[Double]],
        _ rhs: [[Double]],
        accuracy: Double,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            lhs.map { $0.count },
            rhs.map { $0.count },
            file: file, line: line
        )
        
        lhs.enumerated().forEach { row, array in
            array.enumerated().forEach { col, value in
                XCTAssertEqual(
                    lhs[row][col],
                    rhs[row][col],
                    accuracy: accuracy,
                    file: file,
                    line: line
                )
            }
        }
    }
    
    private func assertFindBH(
        source: String,
        result: String,
        _ pixelConnectivity: PixelConnectivity,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let mask = try Image.make(from: source)
        let filler = makeSUT(pixelConnectivity: pixelConnectivity)
        
        let (boundary, hole) = filler.findBoundaryAndHole(hole: mask)
        
        let expectedBoundary = try Image.getBoundary(from: result)
        let expectedHole = try Image.getHole(from: result)
        
        XCTAssertEqual(boundary, expectedBoundary, file: file, line: line)
        XCTAssertEqual(hole, expectedHole, file: file, line: line)
    }
    
}
