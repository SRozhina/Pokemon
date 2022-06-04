import UIKit

protocol GridErrorViewDelegate: AnyObject {
    func gridErrorViewDidTapButton(_ view: GridErrorView)
}

class GridErrorView: UIView {

    weak var delegate: GridErrorViewDelegate?

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = Image.pokemonPlaceholder
        return view
    }()

    private lazy var reloadButton = UIButton(
        type: .system,
        primaryAction: UIAction(
            title: Localization.Grid.reload,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.gridErrorViewDidTapButton(self)
            }
        )
    )

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = Space.triple
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
        addSubview(stackView)
        [imageView, reloadButton].forEach(stackView.addArrangedSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: -Space.quadruple),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -Space.quadruple),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.triple),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Space.triple),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Space.double),

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            reloadButton.heightAnchor.constraint(equalToConstant: Space.fivefold),
        ])
    }
}
