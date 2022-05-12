import Combine
import Foundation

class PokemonDetailsPresenter {

    weak var view: IPokemonDetailsView?
    weak var moduleOutput: PokemonDetailsModuleOutput?
    private let pokemonsService: IPokemonsService
    private let imageLoader: ImageLoading
    private var pokemon: Pokemon
    private var subscriptions = Set<AnyCancellable>()

    init(
        pokemon: Pokemon,
        pokemonsService: IPokemonsService,
        imageLoader: ImageLoading
    ) {
        self.pokemon = pokemon
        self.pokemonsService = pokemonsService
        self.imageLoader = imageLoader
    }

    private func loadImage() {
        imageLoader.loadImage(from: pokemon.imageUrl)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    guard let self = self else { return }
                    self.pokemon = self.pokemon.with(image: image)
                    let viewModel = PokemonDetailsViewModelFactory.makeViewModel(self.pokemon)
                    self.view?.set(viewModel: viewModel)
                })
            .store(in: &subscriptions)
    }
}

extension PokemonDetailsPresenter: IPokemonDetailsPresenter {
    func setup() {
        let viewModel = PokemonDetailsViewModelFactory.makeViewModel(pokemon)
        view?.set(viewModel: viewModel)

        pokemonsService.fetchPokemonDetails(url: pokemon.detailsUrl)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] details in
                    guard let self = self else { return }
                    let viewModel = PokemonDetailsViewModelFactory.makeViewModel(details, image: self.pokemon.image)
                    self.view?.set(viewModel: viewModel)
                })
            .store(in: &subscriptions)

        if pokemon.image == nil {
            loadImage()
        }
    }

    func didTapClose() {
        moduleOutput?.pokemonDetailsModuleDidClose(self)
    }
}
