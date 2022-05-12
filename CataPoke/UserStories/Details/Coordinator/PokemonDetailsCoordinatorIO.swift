protocol PokemonDetailsCoordinatorInput: AnyObject { }

protocol PokemonDetailsCoordinatorOutput: AnyObject {
    func pokemonDetailsCoordinatorDidClose(_ coordinator: PokemonDetailsCoordinatorInput)
}
