@testable import FillHoleCommand
import ArgumentParser
import Foundation
import XCTest

final class FillHoleCommandTests: XCTestCase {
    func test_configuration_commandName() {
        XCTAssertEqual(FillHoleCommand.configuration.commandName, "fill-hole")
    }
    
    func test_configuration_abstract() {
        XCTAssertEqual(FillHoleCommand.configuration.abstract, "Image Hole Filler.")
    }
    
    func test_configuration_discussion() {
        XCTAssertEqual(
            FillHoleCommand.configuration.discussion,
        """
        `fill-hole` is a command line utility that fills the hole in the image.
        Provide URLs for the source image and hole (mask), \
        parameters of the weight function `z` and `e`, \
        and (optional) output image file name.
        """)
    }
}
