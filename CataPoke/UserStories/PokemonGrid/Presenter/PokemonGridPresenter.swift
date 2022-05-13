import Combine
import Foundation
import UIKit

class PokemonGridPresenter {

    weak var view: IPokemonGridView?
    weak var moduleOutput: PokemonGridModuleOutput?

    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading

    private var subscriptions = Set<AnyCancellable>()
    private lazy var pokemonsQueue = DispatchQueue(label: "com.SRozhina.pokemonsQueue")
    private var pokemons: [Pokemon] = []
    private var viewModels: [PokemonGridViewModel] = []
    private var total = 0
    private var images: [URL: UIImage] = [:]
    private var loadingImages: Set<URL> = []
    private var isLoading = false

    init(
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
    }

    private func makeGridFooterValue() -> GridFooterViewModel? {
        pokemons.count < total ? .loading : nil
    }

    private func loadPokemonPage(errorHandler: @escaping () -> Void) {
        isLoading = true
        return pokemonsService.fetchPokemonsPage(pageSize: Constants.pageSize, from: pokemons.count)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: pokemonsQueue)
            .handleEvents { [weak self] _ in
                self?.isLoading = false
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.handlePokemonPage($0)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {
                    guard case .failure = $0 else { return }
                    errorHandler()
                },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.hideLoading()
                    self.view?.set(
                        viewModels: self.viewModels,
                        footer: self.makeGridFooterValue()
                    )
                }
            )
            .store(in: &subscriptions)
    }

    private func handlePokemonPage(_ page: PokemonPage) {
        total = page.total
        let pokemons = page.pokemons.map { [weak self] in $0.with(image: self?.images[$0.imageUrl]) }
        pokemons.forEach(loadImageIfNeeded)
        self.pokemons.append(contentsOf: pokemons)
        viewModels.append(contentsOf: pokemons.map(PokemonGridViewModelFactory.makeViewModel))
    }

    private func initialLoading() {
        guard !isLoading else { return }

        pokemons = []
        viewModels = []

        loadPokemonPage { [weak self] in
            self?.view?.showError()
        }
    }

    private func loadPage() {
        guard !isLoading else { return }

        loadPokemonPage { [weak self] in
            guard let self = self else { return }
            self.view?.set(viewModels: self.viewModels, footer: .error)
        }
    }

    private func loadImageIfNeeded(pokemon: Pokemon) {
        let url = pokemon.imageUrl
        guard !images.keys.contains(url), !loadingImages.contains(url) else { return }
        pokemonsQueue.async {
            self.loadingImages.insert(url)
        }

        imageLoader.loadImage(from: url)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: pokemonsQueue)
            .handleEvents(receiveOutput: { [weak self] in
                guard let self = self,
                      let image = $0,
                      let index = self.pokemons.firstIndex(where: { $0.name == pokemon.name })
                else { return }
                self.loadingImages.remove(url)
                self.images[url] = image
                self.pokemons[index] = pokemon.with(image: image)
                self.viewModels[index] = .init(name: pokemon.name, image: image)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.set(viewModels: self.viewModels, footer: self.makeGridFooterValue())
                }
            )
            .store(in: &subscriptions)
    }
}

extension PokemonGridPresenter: PokemonGridModuleInput { }

extension PokemonGridPresenter: IPokemonGridPresenter {

    func setup() {
        view?.showLoading()
        initialLoading()
    }

    func didTapReload() {
        view?.hideError()
        view?.showLoading()
        initialLoading()
    }

    func didPullToRefresh() {
        initialLoading()
    }

    func didScrollTo(index: Int) {
        guard !isLoading && (pokemons.count - index) < Constants.prefetchThreshold else { return }
        loadPage()
    }

    func didTap(on viewModel: PokemonGridViewModel) {
        guard let pokemon = pokemons.first(where: { $0.name == viewModel.name }) else { return }
        moduleOutput?.pokemonGridModule(self, didTapPokemon: pokemon)
    }

    func didTapOnReloadPage() {
        view?.set(viewModels: viewModels, footer: .loading)
        loadPage()
    }
}

private extension PokemonGridPresenter {
    enum Constants {
        static let pageSize = 40
        static let prefetchThreshold = 10
    }
}
