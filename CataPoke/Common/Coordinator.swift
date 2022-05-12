import UIKit

class Coordinator: NSObject {

    var viewControllers: [UIViewController] = []
    var currentViewController: UIViewController? { viewControllers.last }

    // swiftlint:disable:next unavailable_function
    func makeInitialViewController() throws -> UIViewController {
        fatalError("Override this method")
    }

    func present(_ viewControllerToPresent: UIViewController) {
        viewControllerToPresent.presentationController?.delegate = self
        viewControllerToPresent.isModalInPresentation = true

        currentViewController?.present(viewControllerToPresent, animated: true) {
            self.viewControllers.append(viewControllerToPresent)
        }
    }

    func push(_ viewController: UIViewController) {
        if let navigationController = currentViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            present(viewController)
        }
    }
}

extension Coordinator: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        _ = viewControllers.popLast()
    }
}
