import Foundation

public final class Balance {
    
    public typealias WeightFunc = (Point, Point) -> Double
    
    private let weighting: WeightFunc
    
    /// Initialize with arbitrary weighting function.
    public init(_ weighting: @escaping WeightFunc) {
        self.weighting = weighting
    }
    
    /// Initialize using default weighting function `1/(||u - v||^z + ε)`
    /// where `ε (epsilon)` is a small float value used to avoid division by zero, and `||u - v||` denotes the euclidean distance between `u` and `v`.
    public init(z: Int = 2, epsilon: Double = 0.001) {
        self.weighting = { u, v in
            let distance = u.euclideanDistance(to: v)
            let divisor = pow(distance, Double(z)) + epsilon
            
            return 1 / divisor
        }
    }
    
    public func weight(_ u: Point, _ v: Point) -> Double {
        return weighting(u, v)
    }
}

extension Balance {
    public static func `default`(z: Int = 2, epsilon: Double = 0.001) -> Self {
        .init(z: z, epsilon: epsilon)
    }
}

extension Point {
    /// [Euclidean distance - Wikipedia](https://en.wikipedia.org/wiki/Euclidean_distance)
    func euclideanDistance(to other: Self) -> Double {
        let dRow = Double(row - other.row)
        let dCol = Double(col - other.col)
        let squared = pow(dRow, 2) + pow(dCol, 2)
        
        return sqrt(squared)
    }
}
