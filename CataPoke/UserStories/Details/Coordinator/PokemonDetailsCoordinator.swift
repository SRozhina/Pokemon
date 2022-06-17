import Swinject
import UIKit

final class PokemonDetailsCoordinator: Coordinator<AppStep> {

    private let container: Container
    private let pokemon: Pokemon

    private weak var output: PokemonDetailsCoordinatorOutput?

    private weak var pokemonDetailsModuleInput: PokemonDetailsModuleInput?
    private var pokemonDetailsCoordinator: PokemonDetailsCoordinatorInput?

    init(
        container: Container,
        pokemon: Pokemon,
        output: PokemonDetailsCoordinatorOutput
    ) {
        self.container = container
        self.pokemon = pokemon
        self.output = output
        super.init()
    }

    @discardableResult
    override func start() -> UIViewController? {
        super.start()

        guard let view = container.resolve(IPokemonDetailsView.self, argument: pokemon),
              let viewController = view as? UIViewController
        else { return nil }
        pokemonDetailsModuleInput = view.presenter
        view.presenter.moduleOutput = self

        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        self.navigationController = navigationController
        return navigationController
    }

    override func navigate(to step: AppStep) -> StepAction {
        switch step {
        case let .pokemonDetails(pokemon):
            let coordinator = PokemonDetailsCoordinator(
                container: container,
                pokemon: pokemon,
                output: self
            )
            self.pokemonDetailsCoordinator = coordinator
            guard let viewController = coordinator.start() else { return .none }
            return .present(viewController, .automatic)

        case .back:
            return .dismiss

        case .pokemonGrid:
            return .none
        }
    }
}

extension PokemonDetailsCoordinator: PokemonDetailsCoordinatorInput { }

extension PokemonDetailsCoordinator: PokemonDetailsModuleOutput {

    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didTapPokemon pokemon: Pokemon) {
        step = .pokemonDetails(pokemon)
    }

    func pokemonDetailsModule(_ module: PokemonDetailsModuleInput, didFetchPokemonDetails details: PokemonDetails) {
        guard let view = container.resolve(IPokemonEvolutionGridView.self, argument: details),
              let viewController = view as? UIViewController
        else { return }
        view.presenter.moduleOutput = self
        pokemonDetailsModuleInput?.showEvolutionGrid(viewController)
    }

    func pokemonDetailsModuleDidClose(_ module: PokemonDetailsModuleInput) {
        step = .back
        pokemonDetailsModuleInput = nil
        output?.pokemonDetailsCoordinatorDidClose(self)
    }
}

extension PokemonDetailsCoordinator: PokemonDetailsCoordinatorOutput {
    func pokemonDetailsCoordinatorDidClose(_ coordinator: PokemonDetailsCoordinatorInput) {
        pokemonDetailsCoordinator = nil
    }
}

extension PokemonDetailsCoordinator: PokemonEvolutionGridModuleOutput {

    func pokemonEvolutionGridModule(_ module: PokemonEvolutionGridModuleInput, didTapPokemon pokemon: Pokemon) {
        step = .pokemonDetails(pokemon)
    }
}
