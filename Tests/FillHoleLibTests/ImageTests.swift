@testable import FillHoleLib
import XCTest

final class ImageTests: XCTestCase {
    func test_rows_cols() {
        XCTAssertEqual(Image.bwHole.rows, 0..<5)
        XCTAssertEqual(Image.bwHole.cols, 0..<8)
    }
    
    func test_subscript() {
        XCTAssertEqual(Image.bwHole[.init(1, 2)], 0)
        XCTAssertEqual(Image.bwHole[.init(0, 0)], 1)

        let image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        XCTAssertEqual(image[.init(-1, 0)], nil)
        XCTAssertEqual(image[.init(0, -1)], nil)
        
        XCTAssertEqual(image[.init(0, 0)], 1)
        XCTAssertEqual(image[.init(0, 1)], 2)
        XCTAssertEqual(image[.init(0, 2)], 3)
        XCTAssertEqual(image[.init(1, 0)], 4)
        XCTAssertEqual(image[.init(1, 1)], 5)
        XCTAssertEqual(image[.init(1, 2)], 6)
        XCTAssertEqual(image[.init(2, 0)], 7)
        XCTAssertEqual(image[.init(2, 1)], 8)
        XCTAssertEqual(image[.init(2, 2)], 9)
        
        XCTAssertEqual(image[.init(3, 0)], nil)
        XCTAssertEqual(image[.init(0, 3)], nil)
    }
    
    func test_isValid() {
        XCTAssertFalse(Image.bwHole.isValid(point: .init(-1,  0)))
        XCTAssertFalse(Image.bwHole.isValid(point: .init( 0, -1)))
        XCTAssertFalse(Image.bwHole.isValid(point: .init(-1, -1)))
        XCTAssertFalse(Image.bwHole.isValid(point: .init(Image.bwHole.cols.endIndex - 1, Image.bwHole.rows.endIndex - 1)))
        
        XCTAssert(Image.bwHole.isValid(point: .init(0, 0)))
        XCTAssert(Image.bwHole.isValid(point: .init(Image.bwHole.rows.endIndex - 1, 0)))
        XCTAssert(Image.bwHole.isValid(point: .init(                            0, Image.bwHole.cols.endIndex - 1)))
        XCTAssert(Image.bwHole.isValid(point: .init(Image.bwHole.rows.endIndex - 1, Image.bwHole.cols.endIndex - 1)))
    }
    
    func test_markMissing() {
        let expectedHole = Image(matrix: [
            [ 0, 0, 0, 0, 0, 0, 0, 0],
            [ 0, 0,-1, 0, 0, 0, 0, 0],
            [ 0, 0,-1,-1,-1,-1, 0, 0],
            [ 0, 0, 0,-1,-1, 0, 0, 0],
            [ 0, 0, 0, 0, 0, 0, 0, 0],
        ])
        
        let marked = Image.bwHole.markMissing()
        
        XCTAssertEqual(marked, expectedHole)
    }
    
    func test_hasSameDimensions_fails_onBadImage() {
        let image = Image(matrix: [
            [1, 2, 3, 0],
            [4, 5, 6],
            [7, 8, 9, 0]
        ])
        let other = Image(matrix: [
            [1, 2, 3, 0],
            [4, 5, 6, 0],
            [7, 8, 9, 0]
        ])
        
        XCTAssertFalse(image.hasSameDimensions(as: other))
    }
    
    func test_hasSameDimensions_fails_onBadHole() {
        let image = Image(matrix: [
            [1, 2, 3, 0],
            [4, 5, 6, 0],
            [7, 8, 9, 0]
        ])
        let other = Image(matrix: [
            [1, 2, 3, 0],
            [4, 5, 6],
            [7, 8, 9, 0]
        ])
        
        XCTAssertFalse(image.hasSameDimensions(as: other))
    }
    
    func test_hasSameDimensions_fails_3x4() {
        let image = Image(matrix: [
            [1, 2, 3, 0],
            [4, 5, 6, 0],
            [7, 8, 9, 0]
        ])
        let other = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        XCTAssertFalse(image.hasSameDimensions(as: other))
    }
    
    func test_hasSameDimensions_fails_4x3() {
        let image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            [0, 1, 2]
        ])
        let other = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        XCTAssertFalse(image.hasSameDimensions(as: other))
    }
    
    func test_hasSameDimensions_succeeds() {
        let image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        let other = Image(matrix: [
            [10, 20, 30],
            [40, 50, 60],
            [70, 80, 90]
        ])
        
        XCTAssert(image.hasSameDimensions(as: other))
    }
    
    func test_isEmpty_fails() throws {
        let image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
     
        XCTAssertFalse(image.isEmpty)
    }
    
    func test_isEmpty_succeeds() throws {
        let image = Image(matrix: [[]])
        
        XCTAssert(image.isEmpty)
    }
    
    func test_dimensions() {
        let image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
        ])
     
        XCTAssertEqual(image.dimensions.rows, 2)
        XCTAssertEqual(image.dimensions.cols, 3)
    }
    
    func test_valueOfX() {
        let image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        XCTAssertEqual(image.value(ofRow: -1, col: 0), nil)
        XCTAssertEqual(image.value(ofRow: 0, col: -1), nil)
        
        XCTAssertEqual(image.value(ofRow: 0, col: 0), 1)
        XCTAssertEqual(image.value(ofRow: 0, col: 1), 2)
        XCTAssertEqual(image.value(ofRow: 0, col: 2), 3)
        XCTAssertEqual(image.value(ofRow: 1, col: 0), 4)
        XCTAssertEqual(image.value(ofRow: 1, col: 1), 5)
        XCTAssertEqual(image.value(ofRow: 1, col: 2), 6)
        XCTAssertEqual(image.value(ofRow: 2, col: 0), 7)
        XCTAssertEqual(image.value(ofRow: 2, col: 1), 8)
        XCTAssertEqual(image.value(ofRow: 2, col: 2), 9)
        
        XCTAssertEqual(image.value(ofRow: 3, col: 0), nil)
        XCTAssertEqual(image.value(ofRow: 0, col: 3), nil)
    }
    
    func test_isInBoundary_pixelConnectivity4() {
        let image = Image(matrix: [
            [0, 0, 0, 0],
            [0,-1, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
        ])
        
        XCTAssertEqual(image.isInBoundary4(0, 0), false)
        XCTAssertEqual(image.isInBoundary4(0, 1), true)
        XCTAssertEqual(image.isInBoundary4(0, 2), false)
        XCTAssertEqual(image.isInBoundary4(0, 3), false)
        
        XCTAssertEqual(image.isInBoundary4(1, 0), true)
        XCTAssertEqual(image.isInBoundary4(1, 1), false)
        XCTAssertEqual(image.isInBoundary4(1, 2), true)
        XCTAssertEqual(image.isInBoundary4(0, 3), false)
        
        XCTAssertEqual(image.isInBoundary4(2, 0), false)
        XCTAssertEqual(image.isInBoundary4(2, 1), true)
        XCTAssertEqual(image.isInBoundary4(2, 2), false)
        XCTAssertEqual(image.isInBoundary4(1, 3), false)
        
        XCTAssertEqual(image.isInBoundary4(3, 0), false)
        XCTAssertEqual(image.isInBoundary4(3, 1), false)
        XCTAssertEqual(image.isInBoundary4(3, 2), false)
        XCTAssertEqual(image.isInBoundary4(3, 3), false)
    }
    
    func test_paint()  {
        var image = Image(matrix: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        image.paint(point: .init(0, 0), withColor: 9)
        image.paint(point: .init(1, 1), withColor: 9)
        
        let expectedResult = Image(matrix: [
            [9, 2, 3],
            [4, 9, 6],
            [7, 8, 9]
        ])
        
        XCTAssertEqual(image, expectedResult)
    }
    
    func test_mask_dump() {
        let image = Image(matrix: [
            [ 0, 0, 1, 0, 0, 0, 0, 0],
            [ 0, 1,-1, 1, 1, 1, 0, 0],
            [ 0, 1,-1,-1,-1,-1, 1, 0],
            [ 0, 0, 1,-1,-1, 1, 0, 0],
            [ 0, 0, 0, 1, 1, 0, 0, 0],
        ])
        let dump = """
          ·  ·  ❍  ·  ·  ·  ·  ·
          ·  ❍  ◼︎  ❍  ❍  ❍  ·  ·
          ·  ❍  ◼︎  ◼︎  ◼︎  ◼︎  ❍  ·
          ·  ·  ❍  ◼︎  ◼︎  ❍  ·  ·
          ·  ·  ·  ❍  ❍  ·  ·  ·
        
        """
        
        XCTAssertEqual(image.dump, dump)
    }
    
    func test_makeMask_fromString() throws {
        let string1 = """
        - - - - - - - - -
        - - - 0 0 0 - - -
        - - - - 0 - - - -
        - - - - - - - - -
        """
        
        let string2 = """
        - - - - - - - - -
        - - - + + + - - -
        - - - - + - - - -
        - - - - - - - - -
        """
        
        let string3 = """
        . . . . . . . . .
        . . . + + + . . .
        . . . . + . . . .
        . . . . . . . . .
        """
        
        let string4 = """
        . . . . . .      . . .
        .  . . + + + . . .
        .        . . . +  . . . .
        . . . . . .  . . .
        """
        
        let expectedImage = Image(matrix: [
            [1,  1,  1,  1,  1,  1,  1,  1,  1],
            [1,  1,  1,  0,  0,  0,  1,  1,  1],
            [1,  1,  1,  1,  0,  1,  1,  1,  1],
            [1,  1,  1,  1,  1,  1,  1,  1,  1],
        ])
        
        XCTAssertEqual(try Image.make(from: string1), expectedImage)
        XCTAssertEqual(try Image.make(from: string2), expectedImage)
        XCTAssertEqual(try Image.make(from: string3), expectedImage)
        XCTAssertEqual(try Image.make(from: string4), expectedImage)
    }
    
    func test_makeMask_fails() throws {
        let string = """
        -  -  -  -  -  -
        -  -  0  -  -
        """
        XCTAssertThrowsError(try Image.make(from: string)) { error in
            XCTAssertNotNil(error as? Image.ConversionError)
        }
    }
    
    func test_makeMask_bwHole() throws {
        let string = """
        -  -  -  -  -  -  -  -
        -  -  0  -  -  -  -  -
        -  -  0  0  0  0  -  -
        -  -  -  0  0  -  -  -
        -  -  -  -  -  -  -  -
        """
        XCTAssertEqual(try Image.make(from: string), Image.bwHole)
    }
    
    func test_DSL_boundaryAndHole__3x3_connectivity4() throws {
        let string = """
            -  b  -
            b  0  b
            -  b  -
            """
        
        let boundary = try Image.getBoundary(from: string)
        let hole = try Image.getHole(from: string)
        
        let expectedBoundary = [
                    (0, 1),
            (1, 0),         (1, 2),
                    (2, 1)
        ].map(Point.init)
        
        let expectedHole = [(1, 1)].map(Point.init)
        
        XCTAssertEqual(boundary, Set(expectedBoundary))
        XCTAssertEqual(hole, Set(expectedHole))
    }
    
    func test_DSL_boundaryAndHole_4x5_connectivity4() throws {
        let string = """
            -  b  b  b  -
            b  0  0  0  b
            -  b  0  b  -
            -  -  b  -  -
            """
        
        let boundary = try Image.getBoundary(from: string)
        let hole = try Image.getHole(from: string)
        
        let expectedBoundary = [
                    (0, 1), (0, 2), (0, 3),
            (1, 0),                         (1, 4),
                    (2, 1),         (2, 3),
                            (3, 2)
        ].map(Point.init)
        let expectedHole = [
            (1, 1), (1, 2), (1, 3),
            (2, 2)
        ].map(Point.init)
        
        XCTAssertEqual(boundary, Set(expectedBoundary))
        XCTAssertEqual(hole, Set(expectedHole))
    }
    
    func test_DSL_boundaryAndHole_4x4a_connectivity8() throws {
        let string = """
            b  b  b  b
            b  0  0  b
            b  b  0  b
            -  b  b  b
            """
        
        let boundary = try Image.getBoundary(from: string)
        let hole = try Image.getHole(from: string)

        let expectedBoundary = [
            (0, 0), (0, 1), (0, 2), (0, 3),
            (1, 0),                 (1, 3),
            (2, 0), (2, 1),         (2, 3),
                    (3, 1), (3, 2), (3, 3)
        ].map(Point.init)
        let expectedHole = [
                    (1, 1), (1, 2),
                            (2, 2)
        ].map(Point.init)

        XCTAssertEqual(boundary, Set(expectedBoundary))
        XCTAssertEqual(hole, Set(expectedHole))
    }
}

private extension Image {
    func value(ofRow row: Int, col: Int) -> Value? {
        return self[.init(row, col)]
    }
}
