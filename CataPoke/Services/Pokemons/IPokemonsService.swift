import Combine
import Foundation

// TODO split service and app models if needed
protocol IPokemonsService {
    func fetchPokemonsPage(pageSize: Int, from index: Int) -> AnyPublisher<PokemonPage, Error>
    func fetchPokemonDetails(url: URL) -> AnyPublisher<PokemonDetails, Error>
    func fetchEvolutionChain(url: URL) -> AnyPublisher<EvolutionChain, Error>
}
