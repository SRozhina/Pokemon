import UIKit

enum PokemonDetailsViewModelFactory {
    private static let placeholder = Image.pokemonPlaceholder

    static func makeViewModel(_ pokemon: Pokemon) -> PokemonDetailsViewModel {
        PokemonDetailsViewModel(
            name: pokemon.name,
            image: placeholder,
            specials: [],
            characteristics: []
        )
    }

    static func updateViewModel(_ viewModel: PokemonDetailsViewModel, with specials: [PokemonDetails.Special]) -> PokemonDetailsViewModel {
        .init(
            name: viewModel.name,
            image: viewModel.image,
            specials: specials.map(\.description),
            characteristics: viewModel.characteristics
        )
    }

    static func updateViewModel(_ viewModel: PokemonDetailsViewModel, with characteristics: PokemonDetails) -> PokemonDetailsViewModel {
        .init(
            name: viewModel.name,
            image: viewModel.image,
            specials: viewModel.specials,
            characteristics: makeCharacteristics(characteristics)
        )
    }

    static func updateViewModel(_ viewModel: PokemonDetailsViewModel, with image: UIImage) -> PokemonDetailsViewModel {
        .init(
            name: viewModel.name,
            image: image,
            specials: viewModel.specials,
            characteristics: viewModel.characteristics
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
