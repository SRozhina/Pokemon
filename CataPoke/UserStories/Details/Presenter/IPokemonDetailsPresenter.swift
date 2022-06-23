protocol IPokemonDetailsPresenter: PokemonDetailsModuleInput, EmptyViewControllerDelegate {
    var view: IPokemonDetailsView? { get set }
    var moduleOutput: PokemonDetailsModuleOutput? { get set }

    func setup()
    func didTapClose()
}
