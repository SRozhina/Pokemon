import Combine
import Foundation

final class URLSessionRequestHandler: RequestHandling {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func request<T: Decodable>(route: APIRoute) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: route.asRequest())
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
