import Combine
import Foundation

class URLSessionNetworkRequestHandler: NetworkRequestHandling {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getData(url: URL) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { NetworkRequestError.error($0.localizedDescription) }
            .eraseToAnyPublisher()
    }

    func getData(request: URLRequest) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { NetworkRequestError.error($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
