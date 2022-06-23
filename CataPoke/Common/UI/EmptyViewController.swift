import UIKit

protocol EmptyViewControllerDelegate: AnyObject {
    func emptyViewControllerDidClose(_ viewController: EmptyViewController)
}

class EmptyViewController: UIViewController {

    weak var delegate: EmptyViewControllerDelegate?

    var descriptionText: String {
        get {
            descriptionLabel.text ?? ""
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = Image.pokemonPlaceholder
        return view
    }()

    private lazy var closeButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(didTapCloseButton)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        [
            descriptionLabel,
            imageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        if isModal {
            navigationItem.leftBarButtonItem = closeButton
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.Image.size),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -Constants.Image.topOffset),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Space.quadruple),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.double),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -Space.double),
        ])
    }

    @objc
    private func didTapCloseButton() {
        delegate?.emptyViewControllerDidClose(self)
    }
}

extension EmptyViewController {
    enum Constants {
        enum Image {
            static let size: CGFloat = 200
            static let topOffset: CGFloat = 100
        }
    }
}
