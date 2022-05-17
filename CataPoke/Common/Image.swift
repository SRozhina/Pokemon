import UIKit

enum Image {
    static var pokemonPlaceholder = image(named: "pokemonPlaceholder")

    static var reload = systemImage(named: "arrow.clockwise")

    private static func image(named name: String) -> UIImage {
        let bundle = Bundle(for: BundleToken.self)
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            fatalError("Unable to load image named \(name).")
        }
        return image
    }

    private static func systemImage(named name: String) -> UIImage {
        guard let image = UIImage(systemName: name) else {
            fatalError("Unable to load system image named \(name).")
        }
        return image
    }
}

private final class BundleToken {}
