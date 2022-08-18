public struct Image {
    public typealias Value = Double
    
    private var matrix: [[Value]]
    private let missingMark: Value = -1
    
    public init(matrix: [[Value]]) {
        assert(!matrix.isEmpty)
        
        self.matrix = matrix
    }
}

extension Image: Equatable {}

extension Image {
    public var values: [[Value]] { matrix }
    public var isEmpty: Bool { rows.isEmpty || cols.isEmpty }
    
    public var dimensions: (rows: Int, cols: Int) {
        (rows.count, cols.count)
    }
    
    var rows: Range<Int> { matrix.indices }
    var cols: Range<Int> { matrix[0].indices }
    
    subscript(point: Point) -> Value? {
        guard isValid(point: point) else {
            return nil
        }
        
        return matrix[point.row][point.col]
    }
    
    /// Check that coordinates defined by given point are valid for this Mask.
    func isValid(point: Point) -> Bool {
        rows.contains(point.row) && cols.contains(point.col)
    }
    
    func isInHole(_ point: Point) -> Bool {
        self[point] == missingMark
    }
    
    /// Check if the pixel in the hole boundary.
    /// A boundary pixel is defined as a pixel that is connected to a hole pixel, but is not in the hole itself.
    /// Pixels can be either 4- or 8-connected to the hole.
    /// - Note: This function could be applied only for masks that have hole (missing) pixels marked with -1, otherwise 0.
    func isInBoundary(
        _ point: Point,
        pixelConnectivity: PixelConnectivity
    ) -> Bool {
        // confirm that pixel is valid and is not in the hole
        guard isValid(point: point),
              !isInHole(point) else {
            return false
        }
        
        let neighbours = pixelConnectivity.neighbours(of: point)
        let sum = neighbours
            .compactMap({ self[$0] })
            .reduce(0, +)
        
        // if at least one neighbour of the pixel is in the hole,
        // than the sum of neighbour pixel values would be negative
        return sum < .zero
    }
}

extension Image {
    /// Marking a hole (missing) color with `-1`.
    /// This is convenient (and easier) to implement, because the most popular image formats do not support -1 values.
    func markMissing() -> Self {
        let matrix = matrix.map { row in
            row.map { $0 == 0 ? missingMark : 0 }
        }
        
        return .init(matrix: matrix)
    }
    
    mutating func paint(point: Point, withColor color: Value) {
        matrix[point.row][point.col] = color
    }
}

extension Image {
    /// Present Image as a set of pixels.
    var pixels: Set<Pixel<Value>> {
        let pixels = matrix.enumerated()
            .map { row, array in
                array.enumerated().map { col, value in
                    Pixel(point: .init(row, col), value: value)
                }
            }
            .reduce([], +)
        
        return Set(pixels)
    }
}

extension Image {
    func hasSameDimensions(as other: Self) -> Bool {
        let counts = matrix.map { $0.count }
        guard counts.allSatisfy({ $0 == counts[0] }) else {
            return false
        }
        
        let otherCounts = other.matrix.map { $0.count }
        guard otherCounts.allSatisfy({ $0 == otherCounts[0] }) else {
            return false
        }
        
        return counts == otherCounts
    }
}
