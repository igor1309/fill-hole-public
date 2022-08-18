import Foundation
import ImageIO
import UniformTypeIdentifiers

public final class GrayscaleIO {
    
    public init() {}
    
    /// A tuple of pixel data and width
    public typealias Grayscale = (pixels: [UInt8], width: Int)
    
    public func loadAsGrayscale(from imageURL: URL) throws -> Grayscale {
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil)
        else {
            throw FileError.imageSourceError(imageURL)
        }
        
        // load full resolution image
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            throw FileError.cgImageError
        }
        
        let width = cgImage.width
        let height = cgImage.height
        var pixelData = [UInt8](repeating: 0, count: width * height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue)
        else {
            throw FileError.cgContextError
        }
        
        let cgImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: cgImageRect)
        
        return (pixelData, width)
    }
    
    public func savePixelData(
        _ grayscale: Grayscale,
        to imageURL: URL,
        utType: UTType
    ) throws {
        let (pixels, width) = grayscale
        let height = pixels.count / width
        
        guard let destination = CGImageDestinationCreateWithURL(imageURL as CFURL, utType.identifier as CFString, 1, nil)
        else {
            throw FileError.imageDestinationError(imageURL)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        guard let cfData = CFDataCreate(nil, pixels, pixels.count),
              let provider = CGDataProvider(data: cfData)
        else {
            throw FileError.dataError
        }
        
        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: 0),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        else {
            throw FileError.cgImageError
        }
        
        CGImageDestinationAddImage(destination, cgImage, nil)
        
        guard CGImageDestinationFinalize(destination) else {
            throw FileError.writeError
        }
        
        return
    }
    
    public enum FileError: Error, Equatable {
        case imageSourceError(URL)
        case imageDestinationError(URL)
        case cgImageError
        case cgContextError
        case dataError
        case writeError
        
        public var description: String? {
            switch self {
            case let .imageSourceError(url):
                return "Cannot create an image source instance using the URL \"\(url)\"."
                
            case let .imageDestinationError(url):
                return "Cannot create an image destination instance using the URL \"\(url)\"."
                
            case .cgImageError:
                return "Can't create cgImage."
                
            case .cgContextError:
                return "Error initializing CGContext."
                
            case .dataError:
                return "Error creating data."
                
            case .writeError:
                return "Error writing to file."
            }
        }
    }
}
