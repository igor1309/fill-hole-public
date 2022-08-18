import Foundation
import FillHoleLib
import GrayscaleIOLib
import UniformTypeIdentifiers

// MARK: Validator

func makeValidator(
    fileSystem: FileSystem = FileManager.default
) -> Validator {
    .init(fileSystem: fileSystem)
}

extension FileManager: FileSystem {}

// MARK: Runner

func makeRunner(
    z: Int,
    epsilon: Double,
    with connectivity: Connectivity,
    utType: UTType
) -> Runner {
    // MARK: Composition
    let directory = makeDirectory()
    let fileIO = makeFileIO()
    let holeFiller = makeHoleFiller(z: z, epsilon: epsilon, with: connectivity)
    
    return .init(
        directory: directory,
        fileIO: fileIO,
        holeFiller: holeFiller,
        utType: utType
    )
}

// MARK: Directory

private func makeDirectory() -> Directory {
    return FileManager.default
}

extension FileManager: Directory {
    func fileInCurrentDirectory(named name: String) -> URL {
        let path = currentDirectoryPath
        // prevent any directory traversal
        let filename = URL(fileURLWithPath: name).lastPathComponent
        return URL(fileURLWithPath: path).appendingPathComponent(filename)
    }
}

// MARK: FileIO (Loader & Saver)

private func makeFileIO() -> FileIO {
    GrayscaleIO()
}

extension GrayscaleIO: FileIO {
    func load(from url: URL) throws -> FileData {
        try loadAsGrayscale(from: url)
    }
    
    func save(_ fileData: FileData, to url: URL, utType: UTType) throws {
        try savePixelData(fileData, to: url, utType: utType)
    }
}

// MARK: Filler

private func makeHoleFiller(
    z: Int,
    epsilon: Double,
    with connectivity: Connectivity
) -> Filler {
    let balance = Balance(z: z, epsilon: epsilon)
    let filler = HoleFiller(
        pixelConnectivity: connectivity.pixelConnectivity,
        balance: balance
    )
    
    return filler
}

// Connectivity - PixelConnectivity Adapter

extension Connectivity {
    var pixelConnectivity: FillHoleLib.PixelConnectivity {
        switch self {
        case .four: return .four
        case .eight: return .eight
        }
    }
}

// MARK: HoleFiller and Image adapter

extension HoleFiller: Filler {
    func fillHole(
        _ hole: FileData,
        in image: FileData
    ) throws -> FileData {
        let hole = Image(pixels: hole.pixels, width: hole.width)
        let image = Image(pixels: image.pixels, width: image.width)
        let result = try fill(hole, in: image)
        
        return result.fileData
    }
}

extension Image {
    init(pixels: [UInt8], width: Int) {
        let matrix = pixels
            .map { Double($0) / 255.0 }
            .chunked(into: width)
        self.init(matrix: matrix)
    }
    
    var width: Int { dimensions.cols }
    
    var fileData: FileData {
        let pixels: [UInt8] = values.reduce([], +).map {
            .init($0 * 255)
        }
        
        return (pixels, width)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
