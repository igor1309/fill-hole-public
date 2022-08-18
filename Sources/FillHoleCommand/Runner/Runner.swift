import Foundation
import UniformTypeIdentifiers

typealias FileIO = Loader & Saver

struct Runner {
    private let directory: Directory
    private let fileIO: FileIO
    private let holeFiller: Filler
    private let utType: UTType
    
    init(
        directory: Directory,
        fileIO: FileIO,
        holeFiller: Filler,
        utType: UTType
    ) {
        self.directory = directory
        self.fileIO = fileIO
        self.holeFiller = holeFiller
        self.utType = utType
    }
    
    func run(with arguments: FillHoleCommandArguments) throws {
        // read image and hole (mask)
        let image = try fileIO.load(from: arguments.source)
        let hole = try fileIO.load(from: arguments.mask)
        
        // prepare output URL
        let outputURL = outputURL(forFilename: arguments.outputFile)
        
        // fill hole
        let result = try holeFiller.fillHole(hole, in: image)
        
        // write result
        try fileIO.save(result, to: outputURL, utType: utType)
        
        print("source: " + arguments.source.absoluteString)
        print("mask:   " + arguments.mask.absoluteString)
        print("output: " + outputURL.absoluteString)
    }
    
    func outputURL(forFilename filename: String) -> URL {
        var name = filename.trimmingCharacters(in: .whitespaces)
        if let ext = utType.preferredFilenameExtension {
            name += "." + ext
        }
        return directory.fileInCurrentDirectory(named: name)
    }
}
