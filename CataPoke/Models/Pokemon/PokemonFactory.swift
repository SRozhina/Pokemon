enum PokemonFactory {

    static func makePokemons(from species: [Species]) -> [Pokemon] {
        species.map {
            Pokemon(
                name: $0.name,
                detailsUrl: $0.url,
                imageUrl: PokemonImageUrlBuilder.makeUrl(forPokemonId: $0.url.lastPathComponent)
            )
        }
    }
}
