import UIKit

final class PokemonGridCell: UICollectionViewCell, SelfDescriptive {

    var title: String {
        get {
            titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGroupedBackground
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private lazy var gradientView: GradientView = {
        let view = GradientView()
        view.colors = Constants.Gradient.colors
        view.locations = Constants.Gradient.location
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = .systemGray6
        [
            imageView,
            gradientView,
            titleLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Space.double),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.double),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.double),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.double)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gradientView.colors = Constants.Gradient.colors
    }
}

private extension PokemonGridCell {
    enum Constants {
        static let cornerRadius: CGFloat = 20

        enum Gradient {
            static let location: [Float] = [0, 0.75]
            static let colors = [UIColor.clear, UIColor.systemGray]
        }
    }
}
