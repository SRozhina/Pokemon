import UIKit

protocol PokemonGridModule {
    var viewController: UIViewController { get }

    func set(output: PokemonGridModuleOutput)

    func detailsModule(pokemon: Pokemon) -> PokemonDetailsModule
}
