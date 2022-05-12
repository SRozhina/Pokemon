enum PokemonGridModuleError: Error {
    case cannotBuildModule
}

protocol PokemonGridModuleInput { }

protocol PokemonGridModuleOutput: AnyObject {
    func pokemonGridModule(_ module: PokemonGridModuleInput, didTapPokemon: SpeciesResponse)
}
