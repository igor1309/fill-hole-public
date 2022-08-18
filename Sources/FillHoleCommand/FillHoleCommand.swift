import ArgumentParser

public struct FillHoleCommand: AsyncParsableCommand {
    
    public static let configuration = CommandConfiguration(
        commandName: "fill-hole",
        abstract: "Image Hole Filler.",
        discussion: """
        `fill-hole` is a command line utility that fills the hole in the image.
        Provide URLs for the source image and hole (mask), \
        parameters of the weight function `z` and `e`, \
        and (optional) output image file name.
        """
    )
    
    @OptionGroup()
    var arguments: FillHoleCommandArguments
    
    public init() {}
    
    public func validate() throws {
        // MARK: Composition
        let validator = makeValidator()
        
        try validator.validate(arguments: arguments)
    }
    
    mutating public func run() throws {
        // MARK: Composition
        let runner = makeRunner(
            z: arguments.z,
            epsilon: arguments.e,
            with: arguments.connectivity,
            utType: .png
        )
        
        try runner.run(with: arguments)
    }
}
