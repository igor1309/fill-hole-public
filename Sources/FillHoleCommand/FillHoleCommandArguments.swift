import ArgumentParser
import Foundation

struct FillHoleCommandArguments: ParsableArguments {
    @Argument(help: "Source image URL.", transform: URL.init(fileURLWithPath:))
    var source: URL
    
    @Argument(help: "Hole (mask) image URL.", transform: URL.init(fileURLWithPath:))
    var mask: URL
    
    @Argument(help: "`z` parameter of the weight function.")
    var z: Int
    
    @Argument(help: "`e` parameter of the weight function: small float value used to avoid division by zero.")
    var e: Double
    
    @Argument(help: "Pixel connectivity type: 4 or 8.", transform: Connectivity.transform(rawValue:))
    var connectivity: Connectivity
    
    @Argument(help: "(Optional) name of output file without extension. The command only writes to the current directory.")
    var outputFile: String = "output"
}
