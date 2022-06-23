import NeedleFoundation
import UIKit

final class PokemonGridComponent: Component<PokemonGridDependency> {
    lazy var presenter: IPokemonGridPresenter = PokemonGridPresenter(
        pokemonsService: dependency.pokemonsService,
        imageLoader: dependency.imageLoader
    )

    lazy var view: IPokemonGridView = {
        let view = PokemonGridViewController(presenter: presenter)
        presenter.view = view
        return view
    }()

    private lazy var emptyViewController: UIViewController = {
        let view = EmptyViewController()
        view.descriptionText = Localization.Grid.empty
        view.delegate = presenter
        return view
    }()
}

extension PokemonGridComponent: PokemonGridModule {
    var viewController: UIViewController {
        view as? UIViewController ?? emptyViewController
    }

    func set(output: PokemonGridModuleOutput) {
        view.presenter.moduleOutput = output
    }

    func detailsModule(pokemon: Pokemon) -> PokemonDetailsModule {
        PokemonDetailsComponent(parent: self, pokemon: pokemon)
    }
}
