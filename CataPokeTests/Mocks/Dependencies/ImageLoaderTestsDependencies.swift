import NeedleFoundation

protocol ImageLoaderTestsDependencies {
    var networkRequestHandler: NetworkRequestHandlingMock { get }
    var imageCache: ImageCacheMock { get }
}

final class ImageLoaderTestsDependenciesImpl: BootstrapComponent, ImageLoaderTestsDependencies {
    var networkRequestHandler: NetworkRequestHandlingMock {
        shared { NetworkRequestHandlingMock() }
    }

    var imageCache: ImageCacheMock {
        shared { ImageCacheMock() }
    }
}
