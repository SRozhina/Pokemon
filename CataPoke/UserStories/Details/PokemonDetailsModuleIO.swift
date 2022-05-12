enum PokemonDetailsModuleError: Error {
    case cannotBuildModule
}

protocol PokemonDetailsModuleInput: AnyObject { }

protocol PokemonDetailsModuleOutput: AnyObject {
    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didTapPokemon pokemon: Pokemon)
    func pokemonDetailsModuleDidClose(_ module: PokemonDetailsModuleInput)
}
