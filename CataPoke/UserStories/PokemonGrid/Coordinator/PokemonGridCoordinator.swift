import Swinject
import UIKit

final class PokemonGridCoordinator: Coordinator<AppStep> {

    private let container: Container
    private let appWindow: UIWindow

    private var pokemonDetailsCoordinator: PokemonDetailsCoordinatorInput?
    private weak var output: PokemonGridCoordinatorOutput?

    init(
        scene: UIWindowScene,
        container: Container,
        output: PokemonGridCoordinatorOutput
    ) {
        appWindow = UIWindow(windowScene: scene)
        self.container = container
        self.output = output
        super.init()
    }

    @discardableResult
    override func start() -> UIViewController? {
        super.start()

        let navigationController = UINavigationController()
        self.navigationController = navigationController
        appWindow.rootViewController = navigationController
        appWindow.makeKeyAndVisible()

        return navigationController
    }

    override func navigate(to step: AppStep) -> StepAction {
        switch step {
        case .pokemonGrid:
            guard let view = container.resolve(IPokemonGridView.self),
                  let viewController = view as? UIViewController
            else { return .none }
            view.presenter.moduleOutput = self
            return .push(viewController)

        case let .pokemonDetails(pokemon):
            let coordinator = PokemonDetailsCoordinator(
                container: container,
                pokemon: pokemon,
                output: self
            )
            pokemonDetailsCoordinator = coordinator
            guard let viewController = coordinator.start() else { return .none }
            return .present(viewController, .automatic)

        case .back:
            return .none
        }
    }
}

extension PokemonGridCoordinator: PokemonGridCoordinatorInput { }

extension PokemonGridCoordinator: PokemonGridModuleOutput {
    func pokemonGridModule(_ module: PokemonGridModuleInput, didTapPokemon pokemon: Pokemon) {
        step = .pokemonDetails(pokemon)
    }
}

extension PokemonGridCoordinator: PokemonDetailsCoordinatorOutput {
    func pokemonDetailsCoordinatorDidClose(_ coordinator: PokemonDetailsCoordinatorInput) {
        pokemonDetailsCoordinator = nil
    }
}
