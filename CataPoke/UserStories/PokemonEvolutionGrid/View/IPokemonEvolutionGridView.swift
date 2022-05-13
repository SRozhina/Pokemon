protocol IPokemonEvolutionGridView: AnyObject {
    var presenter: IPokemonEvolutionGridPresenter { get set }

    func showLoading()
    func hideLoading()

    func showError()
    func hideError()

    func set(viewModels: [PokemonGridViewModel])
}
