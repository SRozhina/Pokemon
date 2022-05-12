import Swinject

class PokemonGridCoordinator: Coordinator {

    private let container: Container
    private weak var output: PokemonGridCoordinatorOutput?

    private weak var pokemonDetailsModuleInput: PokemonDetailsModuleInput?
    private var pokemonDetailsCoordinator: PokemonDetailsCoordinatorInput?

    init(
        container: Container,
        output: PokemonGridCoordinatorOutput
    ) {
        self.container = container
        self.output = output
    }

    override func makeInitialViewController() throws -> UIViewController {
        guard let view = container.resolve(IPokemonGridView.self),
              let viewController = view as? UIViewController
        else {
            throw PokemonGridModuleError.cannotBuildModule
        }
        view.presenter.moduleOutput = self
        let navigationController = UINavigationController(rootViewController: viewController)
        viewControllers = [navigationController]

        return navigationController
    }
}

extension PokemonGridCoordinator: PokemonGridCoordinatorInput { }

extension PokemonGridCoordinator: PokemonGridModuleOutput {
    func pokemonGridModule(_ module: PokemonGridModuleInput, didTapPokemon pokemon: Pokemon) {
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

extension PokemonGridCoordinator: PokemonDetailsCoordinatorOutput {
    func pokemonDetailsCoordinatorDidClose(_ coordinator: PokemonDetailsCoordinatorInput) {
        dismiss()
        pokemonDetailsCoordinator = nil
    }
}
