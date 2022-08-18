public struct HoleFiller {
    let pixelConnectivity: PixelConnectivity
    let balance: Balance
    
    public init(
        pixelConnectivity: PixelConnectivity,
        balance: Balance
    ) {
        self.pixelConnectivity = pixelConnectivity
        self.balance = balance
    }
}

extension HoleFiller {
    
    /// A set of all the boundary pixel coordinates.
    /// A boundary pixel is defined as a pixel that is connected to a hole pixel, but is not in the hole itself.
    /// Pixels can be either 4- or 8-connected to the hole.
    typealias Boundary = Set<Point>
    
    /// A set of all the hole (missing) pixel coordinates.
    /// You can assume the hole pixels are 8-connected with each other.
    typealias Hole = Set<Point>
    
    /// Every image has only a single hole.
    /// Corner case of holes that touch the boundaries of the image is not handled.
    func findBoundaryAndHole(hole: Image) -> (boundary: Boundary, hole: Hole) {
        let bwHole = hole.markMissing()
        
        var boundary: Boundary = .init()
        var hole: Hole = .init()
        
        for row in bwHole.rows {
            for col in bwHole.cols {
                let point = Point(row, col)
                
                if bwHole.isInBoundary(point, pixelConnectivity: pixelConnectivity) {
                    boundary.insert(point)
                } else if bwHole.isInHole(point) {
                    hole.insert(point)
                }
            }
        }
        
        return (boundary, hole)
    }
}

extension HoleFiller {
    /// Fill the hole in the image using the colors of the hole boundary pixels,
    /// weighted by provided Balance.
    public func fill(
        _ hole: Image,
        in image: Image
    ) throws -> Image {
        guard !image.isEmpty, !hole.isEmpty else {
            throw EmptyImageError()
        }
        
        let (rows, cols) = image.dimensions
        
        guard rows > 2, cols > 2 else {
            throw ImageIsTooSmallError()
        }
        
        guard image.hasSameDimensions(as: hole) else {
            throw DifferentDimensionsError()
        }
        
        var image = image
        let (boundary, hole) = findBoundaryAndHole(hole: hole)
        
        let color = { (point: Point) -> Double in
            let (numerator, denominator) = boundary
                .reduce(into: (0.0, 0.0)) { res, bPoint in
                    let weight = balance.weight(point, bPoint)
                    res.0 += weight * (image[bPoint] ?? 0)
                    res.1 += weight
                }
            return numerator / denominator
        }
        
        hole.forEach {
            image.paint(point: $0, withColor: color($0))
        }
        
        return image
    }
    
    
    struct EmptyImageError: Error {}
    struct ImageIsTooSmallError: Error {}
    struct DifferentDimensionsError: Error {}
}
