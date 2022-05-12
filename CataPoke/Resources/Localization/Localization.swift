// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
import Foundation

public enum Localization {

    public enum Details {

        public enum Characteristics {
            /// Capture rate
            public static let captureRate = localize("details.characteristics.capture_rate")

            public enum Gender {
                /// Gender
                public static let title = localize("details.characteristics.gender.title")
            }

            public enum HapinessRate {
                /// Hapiness
                public static let title = localize("details.characteristics.hapiness_rate.title")
                /// happy
                public static let value = localize("details.characteristics.hapiness_rate.value")
            }
        }

        public enum Special {
            /// baby
            public static let baby = localize("details.special.baby")
            /// legendary
            public static let legendary = localize("details.special.legendary")
            /// mythical
            public static let mythical = localize("details.special.mythical")
        }
    }

    public enum Grid {
        /// Reload pokemons
        public static let reload = localize("grid.reload")
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
