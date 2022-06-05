import Combine
import Foundation
import UIKit

class PokemonDetailsPresenter {

    weak var view: IPokemonDetailsView?
    weak var moduleOutput: PokemonDetailsModuleOutput?
    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading
    private var pokemon: Pokemon
    private var subscriptions = Set<AnyCancellable>()

    private var viewModel: PokemonDetailsViewModel

    init(
        pokemon: Pokemon,
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.pokemon = pokemon
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
        self.viewModel = PokemonDetailsViewModelFactory.makeViewModel(pokemon)
    }

    private func loadImage() {
        imageLoader.loadImage(from: pokemon.imageUrl)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let self = self, let image = $0 else { return }
                    self.viewModel = PokemonDetailsViewModelFactory.updateViewModel(self.viewModel, with: image)
                    self.view?.set(viewModel: self.viewModel)
                })
            .store(in: &subscriptions)
    }
}

extension PokemonDetailsPresenter: IPokemonDetailsPresenter {
    func setup() {
        view?.set(viewModel: viewModel)

        pokemonsService.fetchPokemonDetails(url: pokemon.detailsUrl)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] details in
                    guard let self = self else { return }
                    self.moduleOutput?.pokemonDetailsModule(self, didFetchPokemonDetails: details)
                    self.viewModel = PokemonDetailsViewModelFactory.updateViewModel(self.viewModel, with: details.specials)
                    self.viewModel = PokemonDetailsViewModelFactory.updateViewModel(self.viewModel, with: details)
                    self.view?.set(viewModel: self.viewModel)
                })
            .store(in: &subscriptions)

        loadImage()
    }

    func showEvolutionGrid(_ grid: UIViewController) {
        view?.showEvolutionGrid(grid)
    }

    func didTapClose() {
        moduleOutput?.pokemonDetailsModuleDidClose(self)
    }
}
