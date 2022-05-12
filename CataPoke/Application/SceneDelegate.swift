import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var container = DIContainer.create()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let coordinator = PokemonGridCoordinator(container: container, output: self)
        do {
            let viewController = try coordinator.makeInitialViewController()
            window.rootViewController = viewController
        } catch {
            fatalError("Cannot initialize initial view")
        }
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension SceneDelegate: PokemonGridCoordinatorOutput { }
