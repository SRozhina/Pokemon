import UIKit

class PokemonInfoView: UIView {

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var name: String {
        get {
            nameLabel.text ?? ""
        }
        set {
            nameLabel.text = newValue
        }
    }

    var specials: [String] = [] {
        didSet {
            updateSpecials()
        }
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Space.double
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.double
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.double
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstrains()
    }

    private func setupView() {
        addSubview(stackView)
        [
            imageView,
            textsStackView
        ].forEach(stackView.addArrangedSubview)
        textsStackView.addArrangedSubview(nameLabel)
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.widthAnchor.constraint(equalToConstant: Constants.ImageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: Constants.ImageSize.height),
        ])
    }

    private func updateSpecials() {
        textsStackView.subviews.forEach { $0.removeFromSuperview() }
        textsStackView.addArrangedSubview(nameLabel)
        for special in specials {
            let tag = TagView()
            tag.title = special
            tag.titleColor = UIColor.white
            tag.tagColor = UIColor.systemGray2
            textsStackView.addArrangedSubview(tag)
        }
    }
}

private extension PokemonInfoView {
    enum Constants {
        enum ImageSize {
            static let width: CGFloat = 150
            static let height: CGFloat = 200
        }
    }
}
