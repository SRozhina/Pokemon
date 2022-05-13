@testable import CataPoke
import Combine
import Swinject
import XCTest

class ImageLoaderTests: XCTestCase {
    var container: Container!

    var imageCacheMock: ImageCacheMock!
    var requestHandlingMock: NetworkRequestHandlingMock!
    var imageLoader: ImageLoading!

    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        container = DIContainer.create()

        setupContainer()
        imageCacheMock = container.resolve(ImageCache.self) as? ImageCacheMock
        requestHandlingMock = container.resolve(NetworkRequestHandling.self) as? NetworkRequestHandlingMock
        imageLoader = container.resolve(ImageLoading.self)!
    }

    func testLoadingImageSuccess() throws {
        let data = try XCTUnwrap(TestData.image.pngData())
        requestHandlingMock.getDataUrlReturnValue = Just(data)
            .mapError { _ in CataPokeTestError.networkError }
            .eraseToAnyPublisher()

        loadImage { [weak self] loadedImage in
            guard let self = self else {
                XCTFail("Self was deallocated")
                return
            }
            XCTAssertEqual(data, loadedImage?.pngData())
            XCTAssertEqual(self.imageCacheMock.getImageForCallsCount, 1)
            XCTAssertEqual(self.imageCacheMock.insertImageForCallsCount, 1)
            let insertedData = self.imageCacheMock.insertImageForReceivedArguments
            XCTAssertEqual(insertedData?.image?.pngData(), data)
            XCTAssertEqual(insertedData?.url, TestData.url)
        }
    }

    func testLoadingImageError() throws {
        requestHandlingMock.getDataUrlReturnValue = Fail<Data, Error>(error: CataPokeTestError.networkError).eraseToAnyPublisher()

        loadImage { [weak self] loadedImage in
            guard let self = self else {
                XCTFail("Self was deallocated")
                return
            }
            XCTAssertNil(loadedImage)
            XCTAssertEqual(self.imageCacheMock.getImageForCallsCount, 1)
            XCTAssertEqual(self.imageCacheMock.insertImageForCallsCount, 0)
        }
    }

    func testLoadingCorruptedData() throws {
        let data = Data()
        requestHandlingMock.getDataUrlReturnValue = Just(data)
            .mapError { _ in CataPokeTestError.decodingError }
            .eraseToAnyPublisher()

        loadImage { [weak self] loadedImage in
            guard let self = self else {
                XCTFail("Self was deallocated")
                return
            }
            XCTAssertNil(loadedImage)
            XCTAssertEqual(self.imageCacheMock.getImageForCallsCount, 1)
            XCTAssertEqual(self.imageCacheMock.insertImageForCallsCount, 0)
        }
    }

    func testLoadingImageFromCache() throws {
        imageCacheMock.getImageForReturnValue = TestData.image

        loadImage { [weak self] loadedImage in
            guard let self = self else {
                XCTFail("Self was deallocated")
                return
            }
            XCTAssertEqual(TestData.image.pngData(), loadedImage?.pngData())
            XCTAssertEqual(self.imageCacheMock.getImageForCallsCount, 1)
            XCTAssertEqual(self.imageCacheMock.insertImageForCallsCount, 0)
            XCTAssertEqual(self.requestHandlingMock.getDataRequestCallsCount, 0)
        }
    }

    private func loadImage(valueHandler: @escaping (UIImage?) -> Void) {
        let expectation = expectation(description: #function)

        imageLoader.loadImage(from: TestData.url)
            .sink(
                receiveCompletion: {
                    guard case .failure = $0 else { return }
                    XCTFail("Load image finishes with error")
                },
                receiveValue: { loadedImage in
                    valueHandler(loadedImage)
                    expectation.fulfill()
                }
            )
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 5)
    }
}

extension ImageLoaderTests {

    private func setupContainer() {
        container
            .registerImageCache()
            .registerRequestHandling()
    }
}

extension ImageLoaderTests {
    enum TestData {
        static let image = Image.pokemonPlaceholder
        static let url = URL(string: "https://pokeapi.co")!
    }
}
