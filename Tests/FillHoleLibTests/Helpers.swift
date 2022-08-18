@testable import FillHoleLib

extension Point: CustomStringConvertible {
    public var description: String {
        "(\(row) \(col))"
    }
}

extension Image {
    
    static let bwHole: Self = .init(matrix: [
        [ 1, 1, 1, 1, 1, 1, 1, 1],
        [ 1, 1, 0, 1, 1, 1, 1, 1],
        [ 1, 1, 0, 0, 0, 0, 1, 1],
        [ 1, 1, 1, 0, 0, 1, 1, 1],
        [ 1, 1, 1, 1, 1, 1, 1, 1],
    ])
    
    func isInBoundary4(_ row: Int, _ col: Int) -> Bool {
        isInBoundary(.init(row, col), pixelConnectivity: .four)
    }
    
    var dump: String {
        var string = ""
        for row in rows {
            for col in cols {
                let value = self[.init(row, col)]
                let valueStr = value == 0
                ? "·"
                : value == -1 ? "◼︎" : "❍"
                
                string += "  \(valueStr)"
            }
            
            string += "\n"
        }
        
        return string
    }
    
    // MARK: - DSL

    /// Mask image normally would have values of 0 and 1
    /// so it's safe to assume that 9 would be unique
    static func getBoundary(from string: String) throws -> Set<Point> {
        let pixels = try pixels(from: string, filteringBy: 9)
        let points = pixels.map(\.point)
        
        return Set(points)
    }
    
    ///
    static func getHole(from string: String) throws -> Set<Point> {
        let pixels = try pixels(from: string)
        
        guard let filterValue = pixels.map(\.value).min() else {
            throw NoHoleInEmptyMaskError()
        }
        
        let points = pixels
            .filter { $0.value == filterValue }
            .map(\.point)
        
        return Set(points)
    }
    
    struct NoHoleInEmptyMaskError: Error {}
 
    /// Convert string to the set of pixels by mapping non-whitespace characters to digits,
    /// than transforming to pixels, optionally filtering pixels by provided value.
    /// - Attention: `b` means boundary.
    /// Mask image normally would have values of 0 and 1
    /// so it's safe to assume that 9 would be unique
    static func pixels(
        from string: String,
        filteringBy value: Double? = nil
    ) throws -> Set<Pixel<Double>> {
        let s = string.replacingOccurrences(of: "b", with: "9")
        let image = try Image.make(from: s)
        let pixels = image.pixels
        
        let filtered = pixels
            .filter {
                guard let value = value else {
                    return true
                }
                
                return $0.value == value
            }
        
        return filtered
    }
    
    /// Convert string to mask by mapping non-whitespace characters to digits.
    static func make(from string: String) throws -> Self {
        let rows = string.split(separator: "\n")
            .map { (row: String.SubSequence) -> [Double] in
                let s = row
                    .replacingOccurrences(of: "+", with: "0")
                    .replacingOccurrences(of: "-", with: "1")
                    .replacingOccurrences(of: ".", with: "1")
                    .split(separator: " ")
                    .compactMap { Double($0) }
                return s
            }
        
        let counts = rows.map { $0.count }
        guard counts.allSatisfy({ $0 == counts[0] }) else {
            print(rows)
            throw ConversionError(message: "Rows should have equal lengths.")
        }
        
        return .init(matrix: rows)
    }
    
    struct ConversionError: Error, Equatable {
        let message: String
    }
}
