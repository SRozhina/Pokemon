import Combine
import Foundation

protocol IPokemonsService {
    func fetchPokemonsPage(pageSize: Int, from index: Int) -> AnyPublisher<PokemonPage, Error>
    func fetchPokemonDetails(url: URL) -> AnyPublisher<PokemonDetails, Error>
    func fetchEvolutionChain(url: URL) -> AnyPublisher<[Pokemon], Error>
}
