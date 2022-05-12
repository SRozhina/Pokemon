enum PokemonFactory {

    static func makePokemons(from response: SpeciesResponse, offset: Int) -> [Pokemon] {
        response.results.enumerated().map {
            Pokemon(
                name: $0.element.name,
                image: nil,
                detailsUrl: $0.element.url,
                imageUrl: PokemonImageUrlBuilder.makeUrl(for: "\(offset + $0.offset + 1)")
            )
        }
    }
}
