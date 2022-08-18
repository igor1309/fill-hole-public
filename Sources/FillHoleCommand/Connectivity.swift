/// [Pixel connectivity - Wikipedia](https://en.wikipedia.org/wiki/Pixel_connectivity)
enum Connectivity: Int {
    /// 4-connected pixels are neighbors to every pixel that touches one of their edges.
    /// These pixels are connected horizontally and vertically.
    case four = 4
    
    /// 8-connected pixels are neighbors to every pixel that touches one of their edges or corners.
    /// These pixels are connected horizontally, vertically, and diagonally.
    case eight = 8
    
    static func transform(rawValue: String) throws -> Self {
        guard let int = Int(rawValue),
              let value = Self.init(rawValue: int) else {
            throw InitError()
        }
        
        return value
    }
    
    struct InitError: Error {}
}

