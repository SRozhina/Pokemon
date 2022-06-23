import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoordinator: PokemonGridCoordinator!

    private var pokemonGridCoordinator: PokemonGridCoordinatorInput?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        registerProviderFactories()

        let appCoordinator = PokemonGridCoordinator(
            scene: windowScene,
            module: PokemonGridFactory.pokemonGridModule,
            output: self
        )
        self.appCoordinator = appCoordinator
        appCoordinator.start()
        appCoordinator.step = .pokemonGrid
    }
}

extension SceneDelegate: PokemonGridCoordinatorOutput { }
