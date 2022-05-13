protocol IPokemonEvolutionGridPresenter: AnyObject, PokemonEvolutionGridModuleInput {
    var view: IPokemonEvolutionGridView? { get set }
    var moduleOutput: PokemonEvolutionGridModuleOutput? { get set }

    func setup()
    func didTapReload()
    func didTap(on: PokemonGridViewModel)
}
