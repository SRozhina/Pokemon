import NeedleFoundation
import UIKit

final class PokemonEvolutionGridComponent: Component<PokemonEvolutionGridDependency> {

    private let details: PokemonDetails

    init(parent: Scope, details: PokemonDetails) {
        self.details = details
        super.init(parent: parent)
    }

    lazy var presenter: IPokemonEvolutionGridPresenter = PokemonEvolutionGridPresenter(
        details: details,
        pokemonsService: dependency.pokemonsService,
        imageLoader: dependency.imageLoader
    )

    lazy var view: IPokemonEvolutionGridView = {
        let view = PokemonEvolutionGridViewController(presenter: presenter)
        presenter.view = view
        return view
    }()
}

extension PokemonEvolutionGridComponent: PokemonEvolutionGridModule {
    var viewController: UIViewController {
        view as? UIViewController ?? UIViewController()
    }

    func set(output: PokemonEvolutionGridModuleOutput) {
        view.presenter.moduleOutput = output
    }
}
