import Combine
import UIKit

final class ImageLoader: ImageLoading {

    private let session: URLSession
    private let cache: ImageCache

    init(
        cache: ImageCache,
        session: URLSession = .shared
    ) {
        self.session = session
        self.cache = cache
    }

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.getImage(for: url) {
            return Just(image).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map { data, _ -> UIImage? in return UIImage(data: data) }
            .catch { _ in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache.insertImage(image, for: url)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
