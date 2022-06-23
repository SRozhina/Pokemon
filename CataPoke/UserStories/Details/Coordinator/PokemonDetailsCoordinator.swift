import UIKit

final class PokemonDetailsCoordinator: Coordinator<AppStep> {

    private let module: PokemonDetailsModule

    private weak var output: PokemonDetailsCoordinatorOutput?

    private weak var pokemonDetailsModuleInput: PokemonDetailsModuleInput?
    private var pokemonDetailsCoordinator: PokemonDetailsCoordinatorInput?

    init(
        module: PokemonDetailsModule,
        output: PokemonDetailsCoordinatorOutput
    ) {
        self.module = module
        self.output = output
        super.init()
    }

    @discardableResult
    override func start() -> UIViewController? {
        super.start()
        module.set(output: self)
        pokemonDetailsModuleInput = module.input

        let navigationController = UINavigationController()
        navigationController.viewControllers = [module.viewController]
        self.navigationController = navigationController
        return navigationController
    }

    override func navigate(to step: AppStep) -> StepAction {
        switch step {
        case .pokemonDetails:
            return .none

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
        let evolutionGridModule = self.module.evolutionGridModule(details: details)
        evolutionGridModule.set(output: self)
        pokemonDetailsModuleInput?.showEvolutionGrid(evolutionGridModule.viewController)
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
