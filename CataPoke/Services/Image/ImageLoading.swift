import Combine
import UIKit

protocol ImageLoading {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
