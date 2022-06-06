import UIKit

class PokemonDetailsViewController: UIViewController {

    var presenter: IPokemonDetailsPresenter

    private lazy var pokemonInfoView = PokemonInfoView()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.triple
        view.layoutMargins = UIEdgeInsets(top: 0, left: Space.double, bottom: 0, right: Space.double)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var characteristicsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.single
        view.distribution = .fillEqually
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
        setupConstraints()
    }

    private func setupView() {
        navigationItem.leftBarButtonItem = closeButton

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        [
            pokemonInfoView,
            characteristicsStackView,
        ].forEach(contentStackView.addArrangedSubview)

        presenter.setup()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
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
