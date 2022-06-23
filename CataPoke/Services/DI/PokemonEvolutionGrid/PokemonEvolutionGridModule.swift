import UIKit

protocol PokemonEvolutionGridModule {
    var viewController: UIViewController { get }

    func set(output: PokemonEvolutionGridModuleOutput)
}
