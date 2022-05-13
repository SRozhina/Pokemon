import Combine
import Foundation

protocol PokemonRequestHandling {
    func request<T: Decodable>(route: APIRoute) -> AnyPublisher<T, Error>
}
