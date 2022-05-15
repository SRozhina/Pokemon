import Foundation
import UIKit

enum PokemonDetailsModuleError: Error {
    case cannotBuildModule
}

protocol PokemonDetailsModuleInput: AnyObject {
    func showEvolutionGrid(_ grid: UIViewController)
}

protocol PokemonDetailsModuleOutput: AnyObject {
    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didTapPokemon pokemon: Pokemon)
    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didFetchPokemonDetails details: PokemonDetails)
    func pokemonDetailsModuleDidClose(_ module: PokemonDetailsModuleInput)
}
