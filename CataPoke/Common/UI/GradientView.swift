import UIKit

final class GradientView: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        guard let gradient = layer as? CAGradientLayer else {
            fatalError("Cannot typecast layer")
        }
        return gradient
    }

    var colors: [UIColor] = [] {
        didSet {
            gradientLayer.colors = colors.map { $0.cgColor }
        }
    }

    var locations: [Float]? {
        get {
            gradientLayer.locations?.map { $0.floatValue }
        }
        set {
            gradientLayer.locations = newValue?.map { NSNumber(value: $0) }
        }
    }
}
