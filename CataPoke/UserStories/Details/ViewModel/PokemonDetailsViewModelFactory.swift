import UIKit

enum PokemonDetailsViewModelFactory {
    private static let placeholder = Image.pokemonPlaceholder

    static func makeViewModel(_ pokemon: Pokemon) -> PokemonDetailsViewModel {
        PokemonDetailsViewModel(
            name: pokemon.name,
            image: pokemon.image ?? placeholder,
            specials: [],
            characteristics: []
        )
    }

    static func makeViewModel(_ details: PokemonDetails, image: UIImage?) -> PokemonDetailsViewModel {
        PokemonDetailsViewModel(
            name: details.name,
            image: image ?? placeholder,
            specials: details.specials.map(\.description),
            characteristics: makeCharacteristics(details)
        )
    }

    private static func makeCharacteristics(_ details: PokemonDetails) -> [PokemonDetailsViewModel.Characteristic] {
        [
            .init(
                title: Localization.Details.Characteristics.captureRate,
                description: "\(details.captureRate)%"
            ),
            .init(
                title: Localization.Details.Characteristics.Gender.title,
                description: details.possibleGender.description
            ),
            .init(
                title: Localization.Details.Characteristics.HapinessRate.title,
                description: "\(details.happinessRate)% \(Localization.Details.Characteristics.HapinessRate.value)"
            ),
        ]
    }
}
