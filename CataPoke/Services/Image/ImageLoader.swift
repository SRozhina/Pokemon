import Combine
import UIKit

final class ImageLoader: ImageLoading {

    private let requestHandling: NetworkRequestHandling
    private let cache: ImageCache

    init(
        requestHandling: NetworkRequestHandling,
        cache: ImageCache
    ) {
        self.requestHandling = requestHandling
        self.cache = cache
    }

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.getImage(for: url) {
            return Just(image).eraseToAnyPublisher()
        }
        return requestHandling.getData(url: url)
            .map { UIImage(data: $0) }
            .catch { _ in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache.insertImage(image, for: url)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
