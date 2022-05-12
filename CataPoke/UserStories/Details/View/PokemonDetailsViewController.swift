import UIKit

class PokemonDetailsViewController: UIViewController {

    var presenter: IPokemonDetailsPresenter

    init(presenter: IPokemonDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("PokemonDetailsViewController could not be initialized via stroyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO initial setup
    }
}

extension PokemonDetailsViewController: IPokemonDetailsView {

    func set(viewModel: PokemonDetailsViewModel) {
        // TODO update view
    }
}
