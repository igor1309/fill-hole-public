public enum PixelConnectivity: Int {
    /// 4-connected pixels are neighbors to every pixel that touches one of their edges.
    /// These pixels are connected horizontally and vertically.
    case four = 4
    
    /// 8-connected pixels are neighbors to every pixel that touches one of their edges or corners.
    /// These pixels are connected horizontally, vertically, and diagonally.
    case eight = 8
}

extension PixelConnectivity {
    /// Return the neighbours of the given `Point`.
    /// - Note: Func `neighbours(ofPoint:)` does not check if pixel coordinate is valid.
    ///
    func neighbours(of point: Point) -> [Point] {
        let r = point.row
        let c = point.col
        
        switch self {
        case .four:
            return [
                            (r - 1, c),
                (r, c - 1),             (r, c + 1),
                            (r + 1, c),
            ].map(Point.init)
            
        case .eight:
            return [
                (r - 1, c - 1), (r - 1, c), (r - 1, c + 1),
                (r,     c - 1),             (r,     c + 1),
                (r + 1, c - 1), (r + 1, c), (r + 1, c + 1),
            ].map(Point.init)
        }
    }
}
