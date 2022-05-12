import UIKit

struct PokemonDetails {
    let name: String
    let happinessRate: Int
    let captureRate: Int
    let possibleGender: Gender
    let specials: [Special]
    let evolutionUrl: URL
}

extension PokemonDetails {
    enum Special: Codable {
        case baby
        case legendary
        case mythical

        var description: String {
            switch self {
            case .baby:
                return Localization.Details.Special.baby

            case .legendary:
                return Localization.Details.Special.legendary

            case .mythical:
                return Localization.Details.Special.mythical
            }
        }
    }
}

extension PokemonDetails {
    enum Gender: Codable {
        case male(rate: Int)
        case female(rate: Int)
        case genderless

        var description: String {
            switch self {
            case let .male(rate):
                return "\(rate)% male"

            case let .female(rate):
                return "\(rate)% female"

            case .genderless:
                return "no"
            }
        }
    }
}
