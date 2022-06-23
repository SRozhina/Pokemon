import UIKit

protocol PokemonDetailsModule {
    var viewController: UIViewController { get }
    var input: PokemonDetailsModuleInput { get }

    func set(output: PokemonDetailsModuleOutput)

    func evolutionGridModule(details: PokemonDetails) -> PokemonEvolutionGridModule
}
