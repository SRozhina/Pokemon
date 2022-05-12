import UIKit

struct PokemonDetailsViewModel {
    let name: String
    let image: UIImage
    let specials: [String]
    let characteristics: [Characteristic]
}

extension PokemonDetailsViewModel {
    struct Characteristic {
        let title: String
        let description: String
    }
}
