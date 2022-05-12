import UIKit

class TagView: UIView {

    var title: String {
        get {
            titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    var titleColor: UIColor? {
        get {
            titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
        }
    }

    var tagColor: UIColor? {
        get {
            titleContainer.backgroundColor
        }
        set {
            titleContainer.backgroundColor = newValue
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Space.double
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
        addSubview(titleContainer)
        titleContainer.addSubview(titleLabel)
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: titleContainer.topAnchor, constant: Space.single),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: Space.single),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -Space.single),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: titleContainer.bottomAnchor, constant: -Space.single),

            titleContainer.topAnchor.constraint(equalTo: topAnchor),
            titleContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            titleContainer.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleContainer.heightAnchor.constraint(equalToConstant: Space.quadruple),
        ])
    }
}
