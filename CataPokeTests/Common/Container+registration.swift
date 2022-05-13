@testable import CataPoke
import Swinject

extension Container {
    @discardableResult
    func registerImageCache() -> Container {
        register(ImageCache.self) { _ in
            ImageCacheMock()
        }
        .inObjectScope(.container)

        return self
    }

    @discardableResult
    func registerRequestHandling() -> Container {
        register(NetworkRequestHandling.self) { _ in
            NetworkRequestHandlingMock()
        }
        .inObjectScope(.container)

        return self
    }
}
