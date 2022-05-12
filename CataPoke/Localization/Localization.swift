// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
import Foundation

public enum Localization {

    public enum Grid {
        /// POKéMON
        public static let title = localize("grid.title")
    }
}

extension Localization {

    fileprivate static func localize(_ key: String, _ args: CVarArg...) -> String {
        String(format: NSLocalizedString(key, comment: ""),
               locale: Locale.current,
               arguments: args)
    }
}
