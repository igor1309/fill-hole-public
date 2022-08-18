import GrayscaleIOLib
import XCTest

final class GrayscaleIOTests: XCTestCase {
    
    func test_testBundle_hasSampleImages() throws {
        _ = try lenaURL()
        _ = try resourceURL(name: "lena_grayscale_half")
        _ = try resourceURL(name: "lena_grayscale")
        _ = try resourceURL(name: "road", ext: "JPG")
    }
    
    func test_loadAsGrayscale_throwsOnBadURL() throws {
        let imageURL = try XCTUnwrap(URL(string: "any-url"))
        
        XCTAssertThrowsError(try load(from: imageURL)) { error in
            XCTAssertEqual(error as? FileError, .imageSourceError(imageURL))
        }
    }
    
    func test_loadAsGrayscale_loadsCorrectDimensionsForLena() throws {
        let imageURL = try lenaURL()
        let (_, width, height) = try load(from: imageURL)
        
        XCTAssertEqual(width, 512)
        XCTAssertEqual(height, 512)
    }
    
    func test_loadAsGrayscale_loadsCorrectDimensionsForRoad() throws {
        let imageURL = try resourceURL(name: "road", ext: "JPG")
        let (_, width, height) = try load(from: imageURL)
        
        XCTAssertEqual(width, 375)
        XCTAssertEqual(height, 900)
    }
    
    func test_loadAsGrayscale_loadsCorrectGrayscale() throws {
        let sourceURL = try lenaURL()
        let sampleURL = try resourceURL(name: "lena_grayscale")
        let sut = makeSUT()
        let grayscale = try sut.loadAsGrayscale(from: sourceURL)
        let tempURL = temporaryFileURL()
        
        try sut.savePixelData(grayscale, to: tempURL)
        
        let tempURLData = try Data(contentsOf: tempURL)
        let sampleURLData = try Data(contentsOf: sampleURL)
        
        XCTAssertFalse(tempURLData.isEmpty)
        XCTAssertEqual(sampleURLData, tempURLData)
    }
    
    func test_loadAsGrayscale_loadsCorrectGrayscale_Half() throws {
        let sourceURL = try lenaURL()
        let sampleURL = try resourceURL(name: "lena_grayscale_half")
        let sut = makeSUT()
        let grayscale = try sut.loadAsGrayscale(from: sourceURL)
        let tempURL = temporaryFileURL()
        let half = (grayscale.pixels.map { $0 / 2 }, grayscale.width)
        
        try sut.savePixelData(half, to: tempURL)
        
        let tempURLData = try Data(contentsOf: tempURL)
        let sampleURLData = try Data(contentsOf: sampleURL)
        
        XCTAssertFalse(tempURLData.isEmpty)
        XCTAssertEqual(sampleURLData, tempURLData)
    }
    
    func test_loadAsGrayscale_loadsDataDifferentFromSource_lena() throws {
        let roadURL = try lenaURL()
        let sut = makeSUT()
        let grayscale = try sut.loadAsGrayscale(from: roadURL)
        let tempURL = temporaryFileURL()
        
        try sut.savePixelData(grayscale, to: tempURL)
        
        let tempURLData = try Data(contentsOf: tempURL)
        let roadURLData = try Data(contentsOf: roadURL)
        
        XCTAssertFalse(tempURLData.isEmpty)
        XCTAssertNotEqual(roadURLData, tempURLData)
    }
    
    func test_loadAsGrayscale_loadsDataDifferentFromSource_road() throws {
        let roadURL = try resourceURL(name: "road", ext: "JPG")
        let sut = makeSUT()
        let grayscale = try sut.loadAsGrayscale(from: roadURL)
        let tempURL = temporaryFileURL()
        
        try sut.savePixelData(grayscale, to: tempURL)
        
        let tempURLData = try Data(contentsOf: tempURL)
        let roadURLData = try Data(contentsOf: roadURL)
        
        XCTAssertFalse(tempURLData.isEmpty)
        XCTAssertNotEqual(roadURLData, tempURLData)
    }
    
    func test_save_loadsSameGrayscale() throws {
        let grayscale: GrayscaleIO.Grayscale = ([2, 4, 6], 3)
        let outputURL = temporaryFileURL()
        let sut = makeSUT()
        
        try sut.savePixelData(grayscale, to: outputURL)
        let saved = try sut.loadAsGrayscale(from: outputURL)
        
        XCTAssertEqual(saved.pixels, grayscale.pixels)
        XCTAssertEqual(saved.width, grayscale.width)
    }
    
    func test_save_afterLoad_savesGrayscale_lena() throws {
        let roadURL = try lenaURL()
        let sut = makeSUT()
        let grayscale = try sut.loadAsGrayscale(from: roadURL)
        let tempURL = temporaryFileURL()
        
        try sut.savePixelData(grayscale, to: tempURL)
        let saved = try sut.loadAsGrayscale(from: tempURL)
        
        XCTAssertEqual(grayscale.pixels, saved.pixels)
        XCTAssertEqual(grayscale.width, saved.width)
    }
    
    func test_save_afterLoad_savesGrayscale_road() throws {
        let roadURL = try resourceURL(name: "road", ext: "JPG")
        let sut = makeSUT()
        let grayscale = try sut.loadAsGrayscale(from: roadURL)
        let tempURL = temporaryFileURL()
        
        try sut.savePixelData(grayscale, to: tempURL)
        let saved = try sut.loadAsGrayscale(from: tempURL)
        
        XCTAssertEqual(grayscale.pixels, saved.pixels)
        XCTAssertEqual(grayscale.width, saved.width)
    }
    
    func testFileErrorDescription() {
        let errors: [FileError] = [
            .imageSourceError(anyURL()),
            .imageDestinationError(anyURL()),
            .cgImageError,
            .cgContextError,
            .dataError,
            .writeError
        ]
        let descriptions = errors.compactMap(\.description)
        let expectedDescriptions = [
            "Cannot create an image source instance using the URL \"any-url\".",
            "Cannot create an image destination instance using the URL \"any-url\".",
            "Can\'t create cgImage.",
            "Error initializing CGContext.",
            "Error creating data.",
            "Error writing to file."
        ]
        
        XCTAssertEqual(descriptions, expectedDescriptions)
    }
    
    func test_saveModifiedGrayscale_useToCreateSamples() throws {
        let sourceURL = try lenaURL()
        var outputURL = sourceURL
        outputURL.deleteLastPathComponent()
        outputURL.appendPathComponent("output.png")
        print(outputURL.path)
        
        let sut = makeSUT()
        
        let (pixels, width) = try sut.loadAsGrayscale(from: sourceURL)
        let modified = pixels//.map { $0 / 2}
        
        try sut.savePixelData((modified, width), to: outputURL)
    }
    
    // MARK: - Helpers
    
    typealias FileError = GrayscaleIO.FileError
    
    private func makeSUT() -> GrayscaleIO {
        .init()
    }
    
    private func load(from imageURL: URL) throws -> (
        data: [UInt8],
        width: Int,
        height: Int
    ) {
        let sut = makeSUT()
        let (pixels, width) = try sut.loadAsGrayscale(from: imageURL)
        let height = pixels.count / width
        
        return (pixels, width, height)
    }
    
    private func lenaURL(
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> URL {
        try resourceURL(name: "Lenna")
    }
    
    private func anyURL(_ string: String = "any-url") -> URL {
        .init(string: string)!
    }
}

private extension GrayscaleIO {
    func savePixelData(_ grayscale: Grayscale, to imageURL: URL) throws {
        try savePixelData(grayscale, to: imageURL, utType: .png)
    }

}
