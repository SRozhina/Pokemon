class PokemonGridPresenter {

    weak var view: IPokemonGridView?
    weak var moduleOutput: PokemonGridModuleOutput?

    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading

    init(
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
    }
}

extension PokemonGridPresenter: PokemonGridModuleInput { }

extension PokemonGridPresenter: IPokemonGridPresenter {

    func setup() {
        // TODO load initial data
    }

    func didTapReload() {
        // reload data after error
    }

    func didPullToRefresh() {
        // reload data after PTR
    }

    func didScrollTo(index: Int) {
        // load more data
    }

    func didTap(on: PokemonGridViewModel) {
        // open pokemon details
    }

    func didTapOnReloadBatch() {
        // reload batch after error
    }
}
