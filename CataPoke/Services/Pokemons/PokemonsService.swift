import Combine
import Foundation

final class PokemonsService: IPokemonsService {
    private let requestHandler: RequestHandling

    init(requestHandler: RequestHandling) {
        self.requestHandler = requestHandler
    }

    func fetchPokemonsList(batch: Int, from index: Int) -> AnyPublisher<SpeciesResponse, Error> {
        requestHandler.request(route: .getSpeciesList(limit: batch, offset: index))
    }

    func fetchPokemonDetails(url: URL) -> AnyPublisher<SpeciesDetails, Error> {
        requestHandler.request(route: .getSpecies(url))
    }

    func fetchEvolutionChain(url: URL) -> AnyPublisher<EvolutionChain, Error> {
        requestHandler.request(route: .getEvolutionChain(url))
    }
}
