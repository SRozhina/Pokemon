import UIKit

class PokemonGridViewController: UIViewController {

    var presenter: IPokemonGridPresenter

    init(presenter: IPokemonGridPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("PokemonGridViewController could not be initialized via stroyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO initial setup
    }
}

extension PokemonGridViewController: IPokemonGridView {

    func showLoading() {
        // TODO show activity indicator
    }

    func hideLoading() {
        // TODO hide activity indicator
    }

    func showError() {
        // TODO show error
    }

    func hideError() {
        // TODO hide error
    }

    func set(viewModels: [PokemonGridViewModel], footer: GridFooterViewModel?) {
        // TODO update collection with view models
    }
}
