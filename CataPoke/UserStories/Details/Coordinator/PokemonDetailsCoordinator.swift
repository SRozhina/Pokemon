import Swinject
import UIKit

class PokemonDetailsCoordinator: Coordinator {

    private let container: Container
    private let pokemon: Pokemon
    private weak var output: PokemonDetailsCoordinatorOutput?

    private weak var pokemonDetailsModuleInput: PokemonDetailsModuleInput?
    private var pokemonDetailsCoordinator: PokemonDetailsCoordinatorInput?

    init(
        container: Container,
        pokemon: Pokemon,
        output: PokemonDetailsCoordinatorOutput?
    ) {
        self.container = container
        self.pokemon = pokemon
        self.output = output
    }

    override func makeInitialViewController() throws -> UIViewController {
        guard let view = container.resolve(IPokemonDetailsView.self, argument: pokemon),
              let viewController = view as? UIViewController
        else {
            throw PokemonDetailsModuleError.cannotBuildModule
        }
        pokemonDetailsModuleInput = view.presenter
        view.presenter.moduleOutput = self
        let navigationController = UINavigationController(rootViewController: viewController)
        viewControllers = [navigationController]

        return navigationController
    }

    private func openPokemon(_ pokemon: Pokemon) {
        let coordinator = PokemonDetailsCoordinator(
            container: container,
            pokemon: pokemon,
            output: self
        )
        pokemonDetailsCoordinator = coordinator
        guard let viewController = try? coordinator.makeInitialViewController() else { return }
        present(viewController)
    }
}

extension PokemonDetailsCoordinator: PokemonDetailsCoordinatorInput { }

extension PokemonDetailsCoordinator: PokemonDetailsModuleOutput {
    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didTapPokemon pokemon: Pokemon) {
        openPokemon(pokemon)
    }

    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didFetchEvolutionUrl url: URL) {
        guard let view = container.resolve(IPokemonEvolutionGridView.self, argument: url),
              let viewController = view as? UIViewController
        else { return }
        view.presenter.moduleOutput = self
        pokemonDetailsModuleInput?.showEvolutionGrid(viewController)
    }

    func pokemonDetailsModuleDidClose(_ module: PokemonDetailsModuleInput) {
        output?.pokemonDetailsCoordinatorDidClose(self)
        pokemonDetailsModuleInput = nil
    }
}

extension PokemonDetailsCoordinator: PokemonDetailsCoordinatorOutput {
    func pokemonDetailsCoordinatorDidClose(_ coordinator: PokemonDetailsCoordinatorInput) {
        dismiss()
        pokemonDetailsCoordinator = nil
    }
}

extension PokemonDetailsCoordinator: PokemonEvolutionGridModuleOutput {
    func pokemonEvolutionGridModule(_ module: PokemonEvolutionGridModuleInput, didTapPokemon pokemon: Pokemon) {
        openPokemon(pokemon)
    }
}
