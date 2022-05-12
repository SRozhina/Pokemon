import Combine
import Foundation

// TODO split service and app models if needed
protocol IPokemonsService {
    func fetchPokemonsList(batch: Int, from index: Int) -> AnyPublisher<SpeciesResponse, Error>
    func fetchPokemonDetails(url: URL) -> AnyPublisher<SpeciesDetails, Error>
    func fetchEvolutionChain(url: URL) -> AnyPublisher<EvolutionChain, Error>
}
