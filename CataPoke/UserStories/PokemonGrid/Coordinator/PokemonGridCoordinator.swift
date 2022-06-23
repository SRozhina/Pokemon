import UIKit

final class PokemonGridCoordinator: Coordinator<AppStep> {

    private let module: PokemonGridModule
    private let appWindow: UIWindow

    private var pokemonDetailsCoordinator: PokemonDetailsCoordinatorInput?
    private weak var output: PokemonGridCoordinatorOutput?

    init(
        scene: UIWindowScene,
        module: PokemonGridModule,
        output: PokemonGridCoordinatorOutput
    ) {
        appWindow = UIWindow(windowScene: scene)
        self.module = module
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
            module.set(output: self)
            return .push(module.viewController)

        case let .pokemonDetails(pokemon):
            let coordinator = PokemonDetailsCoordinator(
                module: module.detailsModule(pokemon: pokemon),
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
