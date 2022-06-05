import UIKit

final class PokemonGridViewController: UIViewController {

    var presenter: IPokemonGridPresenter

    private var viewModels: [PokemonGridViewModel] = []

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        view.register(PokemonGridCell.self, forCellWithReuseIdentifier: PokemonGridCell.selfDescription)
        view.register(LoadingGridFooterView.self, forCellWithReuseIdentifier: LoadingGridFooterView.selfDescription)
        view.register(ErrorGridFooterView.self, forCellWithReuseIdentifier: ErrorGridFooterView.selfDescription)

        view.refreshControl = UIRefreshControl()
        view.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.delegate = self
        return view
    }()

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { section, _ in
            guard let section = Section(rawValue: section) else {
                fatalError("UnsupportedSection")
            }
            switch section {
            case .main:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Constants.Item.width),
                    heightDimension: .fractionalWidth(Constants.Item.height)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: Space.single,
                    leading: Space.single,
                    bottom: Space.single,
                    trailing: Space.single
                )

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Constants.Group.width),
                    heightDimension: .fractionalWidth(Constants.Group.height)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                return NSCollectionLayoutSection(group: group)

            case .footer:
                let footerItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Constants.Footer.width),
                    heightDimension: .estimated(Constants.Footer.height)
                )
                let footerItem = NSCollectionLayoutItem(layoutSize: footerItemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(Constants.Footer.width),
                    heightDimension: .estimated(Constants.Footer.height)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [footerItem])

                return NSCollectionLayoutSection(group: group)
            }
        }
    }()

    private lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Item>(
        collectionView: collectionView
    ) { collectionView, indexPath, item in
        switch item {
        case let .viewModel(viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PokemonGridCell.selfDescription,
                for: indexPath
            ) as? PokemonGridCell else {
                return UICollectionViewCell()
            }
            cell.title = viewModel.name
            cell.image = viewModel.image
            return cell

        case .footerLoading:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: LoadingGridFooterView.selfDescription,
                for: indexPath
            )

        case .footerError:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: ErrorGridFooterView.selfDescription,
                for: indexPath
            )
        }
    }

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var errorView: GridErrorView = {
        let view = GridErrorView()
        view.delegate = self
        view.isHidden = true
        return view
    }()

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
        title = "POKéMON"
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground
        [
            collectionView,
            activityIndicator,
            errorView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        collectionView.dataSource = collectionViewDataSource

        presenter.setup()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc
    private func didPullToRefresh() {
        presenter.didPullToRefresh()
    }
}

extension PokemonGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.didScrollTo(index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .main:
            guard indexPath.row < viewModels.count else { return }
            let viewModel = viewModels[indexPath.row]
            presenter.didTap(on: viewModel)

        case .footer:
            guard collectionView.cellForItem(at: indexPath) is ErrorGridFooterView else { return }
            presenter.didTapOnReloadPage()
        }
    }
}

extension PokemonGridViewController: IPokemonGridView {
    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func showError() {
        errorView.isHidden = false
    }

    func hideError() {
        errorView.isHidden = true
    }

    func set(viewModels: [PokemonGridViewModel], footer: GridFooterViewModel?) {
        collectionView.refreshControl?.endRefreshing()
        self.viewModels = viewModels
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModels.map { Item.viewModel($0) }, toSection: Section.main)
        switch footer {
        case .loading:
            snapshot.appendItems([.footerLoading], toSection: Section.footer)

        case .error:
            snapshot.appendItems([.footerError], toSection: Section.footer)

        case .none:
            break
        }
        collectionViewDataSource.apply(snapshot)
    }
}

extension PokemonGridViewController: GridErrorViewDelegate {

    func gridErrorViewDidTapButton(_ view: GridErrorView) {
        presenter.didTapReload()
    }
}

private extension PokemonGridViewController {
    enum Section: Int, CaseIterable {
        case main
        case footer
    }

    enum Item: Hashable {
        case viewModel(PokemonGridViewModel)
        case footerLoading
        case footerError
    }
}

private extension PokemonGridViewController {
    enum Constants {
        enum Item {
            static let width: CGFloat = 1 / 3
            static let height: CGFloat = 1 / 2
        }
        enum Group {
            static let width: CGFloat = 1
            static let height: CGFloat = 1 / 2
        }
        enum Footer {
            static let width: CGFloat = 1
            static let height: CGFloat = 60
        }
    }
}
