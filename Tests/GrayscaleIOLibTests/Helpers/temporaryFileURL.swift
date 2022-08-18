import XCTest

extension XCTestCase {
    
    /// [addTeardownBlock: | Apple Developer Documentation](https://developer.apple.com/documentation/xctest/xctestcase/2887226-addteardownblock)
    /**
     Creates a URL for a temporary file on disk. Registers a teardown block to
     delete a file at that URL (if one exists) during test teardown.
     
     You can call the temporaryFileURL() method multiple times from the same test method, or from multiple different test methods, and it will always clean up any temporary file at the returned URL when the test method completes. Registering a teardown block at the point that the URL is constructed keeps the setup and teardown code closely coupled, and removes the need to track file state in an instance variable on the test case subclass.
     */
    func temporaryFileURL() -> URL {
        
        // Create a URL for an unique file in the system's temporary directory.
        let directory = NSTemporaryDirectory()
        let filename = UUID().uuidString
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename)
        
        // Add a teardown block to delete any file at `fileURL`.
        addTeardownBlock {
            do {
                let fileManager = FileManager.default
                // Check that the file exists before trying to delete it.
                if fileManager.fileExists(atPath: fileURL.path) {
                    // Perform the deletion.
                    try fileManager.removeItem(at: fileURL)
                    // Verify that the file no longer exists after the deletion.
                    XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))
                }
            } catch {
                // Treat any errors during file deletion as a test failure.
                XCTFail("Error while deleting temporary file: \(error)")
            }
        }
        
        // Return the temporary file URL for use in a test method.
        return fileURL
        
    }
}
