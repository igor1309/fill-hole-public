struct Validator {
    private let fileSystem: FileSystem
    
    init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
    }
    
    func validate(arguments: FillHoleCommandArguments) throws {
        let source = arguments.source.path
        guard fileSystem.fileExists(atPath: source) else {
            throw ValidationError.noFile(.source, at: source)
        }
        
        let mask = arguments.mask.path
        guard fileSystem.fileExists(atPath: mask) else {
            throw ValidationError.noFile(.mask, at: mask)
        }
        
        let output = arguments.outputFile.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !output.isEmpty else {
            throw ValidationError.badOutput(arguments.outputFile)
        }
        
        guard arguments.e < 0.1 else {
            throw ValidationError.tooBigE(arguments.e)
        }
    }
      
    enum Kind: String {
        case source, mask
    }
    
    enum ValidationError: Error, Equatable {
        case noFile(Kind, at: String)
        case badOutput(String)
        case tooBigE(Double)
        
        var errorDescription: String? {
            switch self {
            case let .noFile(kind, path):
                return "There is no \(kind.rawValue) file at \"\(path)\"."
                
            case let .badOutput(output):
                return "Bad output filename \"\(output)\""
                
            case let .tooBigE(e):
                return "Parameter `e` is too big (\(e))."
            }
        }
    }
}
