import Foundation

class PokemonEvolutionGridPresenter {

    weak var view: IPokemonEvolutionGridView?
    weak var moduleOutput: PokemonEvolutionGridModuleOutput?

    private let url: URL
    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading

    init(
        url: URL,
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.url = url
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
    }
}

extension PokemonEvolutionGridPresenter: PokemonEvolutionGridModuleInput { }

extension PokemonEvolutionGridPresenter: IPokemonEvolutionGridPresenter {

    func setup() {
        // TODO initial loading
    }
    func didTapReload() {
        // TODO reload after error
    }

    func didTap(on: PokemonGridViewModel) {
        // TODO open pokemon details
    }
}
