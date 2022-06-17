import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoordinator: PokemonGridCoordinator!

    private let container = DIContainer.create()
    private var pokemonGridCoordinator: PokemonGridCoordinatorInput?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let appCoordinator = PokemonGridCoordinator(
            scene: windowScene,
            container: container,
            output: self
        )
        self.appCoordinator = appCoordinator
        appCoordinator.start()
        appCoordinator.step = .pokemonGrid
    }
}

extension SceneDelegate: PokemonGridCoordinatorOutput { }
