@testable import FillHoleLib
import XCTest

final class BalanceTests: XCTestCase {
    func test_init_withDefaultWeighting() {
        let (calculator, u, v) = makeSUT()
        
        let distance = calculator.weight(u, v)
        
        XCTAssertEqual(distance, 1 / (26 + 0.001), accuracy: 0.0000001)
    }
    
    func test_init_withDefaultWeightingWithCustomParameters() {
        let (calculator, u, v) = makeSUT(z: 4, epsilon: 0.0001)
        
        let distance = calculator.weight(u, v)
        
        XCTAssertEqual(distance, 1 / (26*26 + 0.0001), accuracy: 0.0000001)
    }
    
    func test_init_withCustomWeighting() {
        let (calculator, u, v) = makeSUT { u, v in
            1/(u.euclideanDistance(to: v) + 0.01)
        }
        
        let distance = calculator.weight(u, v)
        
        XCTAssertEqual(distance, 1 / (sqrt(26.0) + 0.01), accuracy: 0.0000001)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        z: Int = 2,
        epsilon: Double = 0.001
    ) -> (calculator: Balance, u: Point, v: Point) {
        let calculator = Balance(z: z, epsilon: epsilon)
        return makeSUT(calculator.weight(_:_:))
    }
    
    private func makeSUT(
        _ weighting: @escaping Balance.WeightFunc
    ) -> (calculator: Balance, u: Point, v: Point) {
        let calculator = Balance(weighting)
        let u = Point(0, 0)
        let v = Point(1, 5)
        
        return (calculator, u, v)
    }
}
