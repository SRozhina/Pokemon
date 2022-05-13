import Combine
import Foundation

final class PokemonRequestHandler: PokemonRequestHandling {

    private let requestHandling: NetworkRequestHandling
    private let decoder: JSONDecoder

    init(
        requestHandling: NetworkRequestHandling,
        decoder: JSONDecoder
    ) {
        self.requestHandling = requestHandling
        self.decoder = decoder
    }

    func request<T: Decodable>(route: APIRoute) -> AnyPublisher<T, Error> {
        requestHandling.getData(request: route.asRequest())
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
