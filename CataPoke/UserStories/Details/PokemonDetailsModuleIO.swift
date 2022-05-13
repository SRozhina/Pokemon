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
    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didFetchEvolutionUrl url: URL)
    func pokemonDetailsModuleDidClose(_ module: PokemonDetailsModuleInput)
}
