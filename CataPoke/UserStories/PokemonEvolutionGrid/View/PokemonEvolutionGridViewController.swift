import UIKit

class PokemonEvolutionGridViewController: UIViewController {

    var presenter: IPokemonEvolutionGridPresenter

    init(presenter: IPokemonEvolutionGridPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("PokemonEvolutionGridViewController could not be initialized via stroyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO initial setup
    }
}

extension PokemonEvolutionGridViewController: IPokemonEvolutionGridView {
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

    func set(viewModels: [PokemonGridViewModel]) {
        // TODO update collection with view models
    }
}
