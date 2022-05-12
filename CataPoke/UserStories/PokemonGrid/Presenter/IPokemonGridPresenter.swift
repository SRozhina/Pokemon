protocol IPokemonGridPresenter: AnyObject, PokemonGridModuleInput {
    var view: IPokemonGridView? { get set }
    var moduleOutput: PokemonGridModuleOutput? { get set }

    func setup()

    func didTapReload()
    func didPullToRefresh()

    func didScrollTo(index: Int)

    func didTap(on: PokemonGridViewModel)
    func didTapOnReloadPage()
}
