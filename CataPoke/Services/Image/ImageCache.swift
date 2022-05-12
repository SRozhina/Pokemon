import UIKit

protocol ImageCache {
    func getImage(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
}
