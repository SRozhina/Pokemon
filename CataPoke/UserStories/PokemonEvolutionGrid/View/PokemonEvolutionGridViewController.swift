import UIKit

class PokemonEvolutionGridViewController: UIViewController {

    var presenter: IPokemonEvolutionGridPresenter

    private var viewModels: [PokemonGridViewModel] = []

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        view.register(PokemonGridCell.self, forCellWithReuseIdentifier: PokemonGridCell.selfDescription)
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
            collectionView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        collectionView.dataSource = collectionViewDataSource
        presenter.setup()
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.Item.height),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        enum Item {
            static let width: CGFloat = 100
            static let height: CGFloat = 150
        }
    }
}
