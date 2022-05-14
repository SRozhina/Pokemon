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

    private lazy var textsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.double
        view.alignment = .leading
        view.distribution = .fillEqually
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
        [
            imageView,
            textsStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        textsStackView.addArrangedSubview(nameLabel)
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.widthAnchor.constraint(equalToConstant: Constants.ImageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: Constants.ImageSize.height),

            textsStackView.topAnchor.constraint(equalTo: topAnchor),
            textsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Space.double),
            textsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textsStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
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
