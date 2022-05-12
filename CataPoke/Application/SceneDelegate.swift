import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var container = DIContainer.create()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        guard let view = container.resolve(IPokemonGridView.self),
              let viewController = view as? UIViewController else {
            fatalError("Cannot create first app view")
        }
        view.presenter.moduleOutput = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension SceneDelegate: PokemonGridModuleOutput {
    func pokemonGridModule(_ module: PokemonGridModuleInput, didTapPokemon: SpeciesResponse) { }
}
