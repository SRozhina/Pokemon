protocol IPokemonGridPresenter: AnyObject, PokemonGridModuleInput {
    var moduleOutput: PokemonGridModuleOutput? { get set }

    func setup()

    func didTapReload()
    func didPullToRefresh()

    func didScrollTo(index: Int)

    func didTap(on: PokemonGridViewModel)
    func didTapOnReloadBatch()
}
