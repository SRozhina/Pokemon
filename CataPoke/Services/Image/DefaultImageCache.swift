import UIKit

final class DefaultImageCache: ImageCache {

    private let cache = NSCache<AnyObject, AnyObject>()

    func getImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as AnyObject) as? UIImage
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        cache.setObject(image, forKey: url as AnyObject)
    }

    func removeImage(for url: URL) {
        cache.removeObject(forKey: url as AnyObject)
    }
}
