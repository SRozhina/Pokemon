class PokemonDetailsPresenter {

    weak var view: IPokemonDetailsView?
    weak var moduleOutput: PokemonDetailsModuleOutput?
    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading
    private var pokemon: Pokemon

    init(
        pokemon: Pokemon,
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.pokemon = pokemon
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
    }
}

extension PokemonDetailsPresenter: IPokemonDetailsPresenter {
    func setup() {
        // TODO load initial data
    }

    func didTapClose() {
        // TODO close module
    }
}
