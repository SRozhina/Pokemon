enum PokemonGridViewModelFactory {
    static func makeViewModel(_ pokemon: Pokemon) -> PokemonGridViewModel {
        PokemonGridViewModel(
            name: pokemon.name,
            image: pokemon.image ?? Image.pokemonPlaceholder
        )
    }
}
