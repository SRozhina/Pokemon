import UIKit

class PokemonEvolutionGridViewController: UIViewController {

    var presenter: IPokemonEvolutionGridPresenter

    private var viewModels: [PokemonGridViewModel] = []

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        view.register(PokemonGridCell.self, forCellWithReuseIdentifier: PokemonGridCell.selfDescription)
        view.bounces = false
        view.delegate = self
        return view
    }()

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { section, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(Constants.Item.width),
                heightDimension: .absolute(Constants.Item.height)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: Space.single,
                leading: Space.single,
                bottom: Space.single,
                trailing: Space.single
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        }
    }()

    private lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, PokemonGridViewModel>(
        collectionView: collectionView
    ) { collectionView, indexPath, viewModel in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PokemonGridCell.selfDescription,
            for: indexPath
        ) as? PokemonGridCell else {
            return UICollectionViewCell()
        }
        cell.title = viewModel.name
        cell.image = viewModel.image
        return cell
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = Localization.Details.Evolution.title
        label.textAlignment = .center
        return label
    }()

    private lazy var reloadButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Image.reload
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.presenter.didTapReload()
        })
        button.isHidden = true
        return button
    }()

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

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
        setupView()
        setupConstrains()
    }

    private func setupView() {
        [
            titleLabel,
            collectionView,
            reloadButton,
            activityIndicator,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        collectionView.dataSource = collectionViewDataSource
        presenter.setup()
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.height),

            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            reloadButton.heightAnchor.constraint(equalToConstant: Space.fivefold),
            reloadButton.widthAnchor.constraint(equalToConstant: Space.fivefold),
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension PokemonEvolutionGridViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < viewModels.count else { return }
        let viewModel = viewModels[indexPath.row]
        presenter.didTap(on: viewModel)
    }
}

extension PokemonEvolutionGridViewController: IPokemonEvolutionGridView {
    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func showError() {
        reloadButton.isHidden = false
    }

    func hideError() {
        reloadButton.isHidden = true
    }

    func set(viewModels: [PokemonGridViewModel]) {
        self.viewModels = viewModels
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonGridViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels, toSection: .main)
        collectionViewDataSource.apply(snapshot)
    }
}

private extension PokemonEvolutionGridViewController {
    enum Section: Int {
        case main
    }
}

private extension PokemonEvolutionGridViewController {
    enum Constants {
        static let height: CGFloat = 250
        enum Item {
            static let width: CGFloat = 100
            static let height: CGFloat = 150
        }
    }
}
