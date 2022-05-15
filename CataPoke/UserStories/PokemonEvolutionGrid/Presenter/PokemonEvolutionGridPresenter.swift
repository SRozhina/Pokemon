import Combine
import Foundation
import UIKit

class PokemonEvolutionGridPresenter {

    weak var view: IPokemonEvolutionGridView?
    weak var moduleOutput: PokemonEvolutionGridModuleOutput?

    private let details: PokemonDetails
    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading

    private var subscriptions = Set<AnyCancellable>()
    private lazy var pokemonsEvolutionQueue = DispatchQueue(label: "com.SRozhina.pokemonsEvolutionQueue")
    private var pokemons: [Pokemon] = []
    private var viewModels: [PokemonGridViewModel] = []

    init(
        details: PokemonDetails,
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.details = details
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
    }

    private func handlePokemons(_ pokemons: [Pokemon]) {
        pokemons.forEach(loadImage)
        self.pokemons = pokemons
        viewModels = pokemons.map(PokemonGridViewModelFactory.makeViewModel)
    }

    private func loadPokemons() {
        pokemonsService.fetchEvolutionChain(url: details.evolutionUrl)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: pokemonsEvolutionQueue)
            .handleEvents(receiveOutput: { [weak self] in
                self?.handlePokemons($0)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    guard case .failure = $0 else { return }
                    self?.view?.showError()
                },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.hideLoading()
                    self.view?.set(viewModels: self.viewModels)
                }
            )
            .store(in: &subscriptions)
    }

    private func loadImage(for pokemon: Pokemon) {
        let url = pokemon.imageUrl

        imageLoader.loadImage(from: url)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: pokemonsEvolutionQueue)
            .handleEvents(receiveOutput: { [weak self] in
                guard let self = self,
                      let image = $0,
                      let index = self.pokemons.firstIndex(where: { $0.name == pokemon.name })
                else { return }
                self.pokemons[index] = pokemon.with(image: image)
                self.viewModels[index] = .init(name: pokemon.name, image: image)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.set(viewModels: self.viewModels)
                }
            )
            .store(in: &subscriptions)
    }
}

extension PokemonEvolutionGridPresenter: PokemonEvolutionGridModuleInput { }

extension PokemonEvolutionGridPresenter: IPokemonEvolutionGridPresenter {

    func setup() {
        view?.showLoading()
        loadPokemons()
    }

    func didTapReload() {
        view?.hideError()
        view?.showLoading()
        loadPokemons()
    }

    func didTap(on viewModel: PokemonGridViewModel) {
        guard
            viewModel.name != details.name,
            let pokemon = pokemons.first(where: { $0.name == viewModel.name })
        else { return }
        moduleOutput?.pokemonEvolutionGridModule(self, didTapPokemon: pokemon)
    }
}
