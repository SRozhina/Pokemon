// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
import Foundation

enum Localization {

    enum Details {

        enum Characteristics {
            /// Capture rate
            static let captureRate = localize("details.characteristics.capture_rate")

            enum Gender {
                /// Gender
                static let title = localize("details.characteristics.gender.title")
            }

            enum HapinessRate {
                /// Hapiness
                static let title = localize("details.characteristics.hapiness_rate.title")
                /// happy
                static let value = localize("details.characteristics.hapiness_rate.value")
            }
        }

        enum Evolution {
            /// Evolution chain
            static let title = localize("details.evolution.title")
        }

        enum Special {
            /// baby
            static let baby = localize("details.special.baby")
            /// legendary
            static let legendary = localize("details.special.legendary")
            /// mythical
            static let mythical = localize("details.special.mythical")
        }
    }

    enum Grid {
        /// Reload pokemons
        static let reload = localize("grid.reload")
        /// POKéMON
        static let title = localize("grid.title")
    }
}

extension Localization {

    fileprivate static func localize(_ key: String, _ args: CVarArg...) -> String {
        String(format: NSLocalizedString(key, comment: ""),
               locale: Locale.current,
               arguments: args)
    }
}
