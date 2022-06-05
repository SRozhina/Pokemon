import UIKit

enum PokemonGridViewModelFactory {
    static func makeViewModel(_ pokemon: Pokemon) -> PokemonGridViewModel {
        PokemonGridViewModel(
            name: pokemon.name,
            image: Image.pokemonPlaceholder
        )
    }

    static func updateViewModel(_ viewModel: PokemonGridViewModel, with image: UIImage) -> PokemonGridViewModel {
        PokemonGridViewModel(
            name: viewModel.name,
            image: image
        )
    }
}
