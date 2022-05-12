protocol IPokemonDetailsView: AnyObject {
    var presenter: IPokemonDetailsPresenter { get set }

    func set(viewModel: PokemonDetailsViewModel)
}
