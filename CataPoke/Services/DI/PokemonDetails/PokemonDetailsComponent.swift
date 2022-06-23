import NeedleFoundation
import UIKit

final class PokemonDetailsComponent: Component<PokemonDetailsDependency> {
    private let pokemon: Pokemon

    init(parent: Scope, pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(parent: parent)
    }

    lazy var presenter: IPokemonDetailsPresenter = PokemonDetailsPresenter(
        pokemon: pokemon,
        pokemonsService: dependency.pokemonsService,
        imageLoader: dependency.imageLoader
    )

    lazy var view: IPokemonDetailsView  = {
        let view = PokemonDetailsViewController(presenter: presenter)
        presenter.view = view
        return view
    }()

    private lazy var emptyViewController: UIViewController = {
        let view = EmptyViewController()
        view.descriptionText = Localization.Details.empty
        view.delegate = presenter
        return view
    }()
}

extension PokemonDetailsComponent: PokemonDetailsModule {

    var viewController: UIViewController {
        view as? UIViewController ?? emptyViewController
    }

    var input: PokemonDetailsModuleInput {
        presenter
    }

    func set(output: PokemonDetailsModuleOutput) {
        view.presenter.moduleOutput = output
    }

    func evolutionGridModule(details: PokemonDetails) -> PokemonEvolutionGridModule {
        PokemonEvolutionGridComponent(parent: self, details: details)
    }
}
