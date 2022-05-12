protocol IPokemonGridView: AnyObject {
    var presenter: IPokemonGridPresenter { get set }

    func showLoading()
    func hideLoading()

    func showError()
    func hideError()

    func set(viewModels: [PokemonGridViewModel], footer: GridFooterViewModel?)
}
