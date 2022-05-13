import UIKit

class PokemonDetailsViewController: UIViewController {

    var presenter: IPokemonDetailsPresenter

    private lazy var pokemonInfoView = PokemonInfoView()

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.triple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var characteristicsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.single
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var closeButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(didTapCloseButton)
    )

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
        setupView()
        setupConstrains()
    }

    private func setupView() {
        navigationItem.leftBarButtonItem = closeButton

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(contentStackView)

        [
            pokemonInfoView,
            characteristicsStackView,
        ].forEach(contentStackView.addArrangedSubview)

        presenter.setup()
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.double),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.double),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapCloseButton() {
        presenter.didTapClose()
    }
}

extension PokemonDetailsViewController: IPokemonDetailsView {

    func set(viewModel: PokemonDetailsViewModel) {
        pokemonInfoView.image = viewModel.image
        pokemonInfoView.name = viewModel.name
        pokemonInfoView.specials = viewModel.specials

        characteristicsStackView.subviews.forEach { $0.removeFromSuperview() }
        characteristicsStackView.isHidden = viewModel.characteristics.isEmpty
        viewModel.characteristics.forEach {
            let view = CharacteristicView()
            view.title = $0.title
            view.value = $0.description
            characteristicsStackView.addArrangedSubview(view)
        }
    }

    func showEvolutionGrid(_ grid: UIViewController) {
        addChild(grid)
        contentStackView.addArrangedSubview(grid.view)
        grid.didMove(toParent: self)
    }
}
