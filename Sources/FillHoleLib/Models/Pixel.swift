struct Pixel<Value> {
    let point: Point
    let value: Value
}

extension Pixel: Equatable where Value: Equatable {}

extension Pixel: Hashable where Value: Hashable {}
