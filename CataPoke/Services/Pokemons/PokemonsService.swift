import Combine
import Foundation

final class PokemonsService: IPokemonsService {
    private let requestHandler: RequestHandling

    init(requestHandler: RequestHandling) {
        self.requestHandler = requestHandler
    }

    func fetchPokemonsPage(pageSize: Int, from index: Int) -> AnyPublisher<PokemonPage, Error> {
        requestHandler.request(route: .getSpeciesList(limit: pageSize, offset: index))
            .map { PokemonPage(total: $0.count, pokemons: PokemonFactory.makePokemons(from: $0, offset: index)) }
            .eraseToAnyPublisher()
    }

    func fetchPokemonDetails(url: URL) -> AnyPublisher<PokemonDetails, Error> {
        requestHandler.request(route: .getSpecies(url))
            .map(PokemonDetailsFactory.makeDetails)
            .eraseToAnyPublisher()
    }

    func fetchEvolutionChain(url: URL) -> AnyPublisher<EvolutionChain, Error> {
        requestHandler.request(route: .getEvolutionChain(url))
    }
}
