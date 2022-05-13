import Foundation

enum PokemonEvolutionGridModuleError: Error {
    case cannotBuildModule
}

protocol PokemonEvolutionGridModuleInput { }

protocol PokemonEvolutionGridModuleOutput: AnyObject {
    func pokemonEvolutionGridModule(_ module: PokemonEvolutionGridModuleInput, didTapPokemon: Pokemon)
}
