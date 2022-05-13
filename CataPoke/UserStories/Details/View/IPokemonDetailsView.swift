import UIKit

protocol IPokemonDetailsView: AnyObject {
    var presenter: IPokemonDetailsPresenter { get set }

    func set(viewModel: PokemonDetailsViewModel)
    func showEvolutionGrid(_ grid: UIViewController)
}
