import Combine
import Foundation

final class PokemonsService: IPokemonsService {
    private let requestHandler: RequestHandling

    init(requestHandler: RequestHandling) {
        self.requestHandler = requestHandler
    }

    func fetchPokemonsPage(pageSize: Int, from index: Int) -> AnyPublisher<PokemonPage, Error> {
        requestHandler.request(route: .getSpeciesList(limit: pageSize, offset: index))
            .map { PokemonPage(total: $0.count, pokemons: PokemonFactory.makePokemons(from: $0)) }
            .eraseToAnyPublisher()
    }

    func fetchPokemonDetails(url: URL) -> AnyPublisher<PokemonDetails, Error> {
        requestHandler.request(route: .getSpecies(url))
            .map(PokemonDetailsFactory.makeDetails)
            .eraseToAnyPublisher()
    }

    func fetchEvolutionChain(url: URL) -> AnyPublisher<[Pokemon], Error> {
        requestHandler.request(route: .getEvolutionChain(url))
            .map { (chainDetials: EvolutionChainDetails) in
                let chain = self.getPokemons(chainLink: chainDetials.chain)
                return PokemonFactory.makePokemons(from: chain)
            }
            .eraseToAnyPublisher()
    }

    private func getPokemons(chainLink: ChainLink) -> [Species] {
        [chainLink.species] + chainLink.evolvesTo.flatMap(getPokemons)
    }
}
