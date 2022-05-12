import UIKit

final class GradientView: UIView {
    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        layer as! CAGradientLayer
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
