import Swinject

enum DIContainer {

    static func create() -> Container {
        let container = Container()

        container
            .register(NetworkRequestHandling.self) { _ in
                URLSessionNetworkRequestHandler()
            }
            .inObjectScope(.container)

        container
            .register(PokemonRequestHandling.self) { resolver in
                guard let requestHandling = resolver.resolve(NetworkRequestHandling.self) else {
                    fatalError("Cannot resolve NetworkRequestHandling")
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return PokemonRequestHandler(
                    requestHandling: requestHandling,
                    decoder: decoder
                )
            }
            .inObjectScope(.container)

        container
            .register(IPokemonsService.self) { resolver in
                guard let requestHandler = resolver.resolve(PokemonRequestHandling.self) else {
                    fatalError("Cannot resolve PokemonRequestHandling")
                }
                return PokemonsService(requestHandler: requestHandler)
            }
            .inObjectScope(.container)

        container
            .register(ImageCache.self) { _ in
                DefaultImageCache()
            }
            .inObjectScope(.container)

        container
            .register(ImageLoading.self) { resolver in
                guard let requestHandling = resolver.resolve(NetworkRequestHandling.self) else {
                    fatalError("Cannot resolve requestHandling")
                }
                guard let cache = resolver.resolve(ImageCache.self) else {
                    fatalError("Cannot resolve ImageCache")
                }
                return ImageLoader(requestHandling: requestHandling, cache: cache)
            }
            .inObjectScope(.container)

        registerPokemonGrid(in: container)
        registerPokemonDetails(in: container)
        registerPokemonEvolutionGrid(in: container)

        return container
    }

    private static func registerPokemonGrid(in container: Container) {
        container
            .register(IPokemonGridPresenter.self) { resolver in
                guard let pokemonsService = resolver.resolve(IPokemonsService.self) else {
                    fatalError("Cannot resolve IPokemonsService")
                }
                guard let imageLoader = resolver.resolve(ImageLoading.self) else {
                    fatalError("Cannot resolve ImageLoading")
                }
                return PokemonGridPresenter(pokemonsService: pokemonsService, imageLoader: imageLoader)
            }

        container
            .register(IPokemonGridView.self) { resolver in
                guard let presenter = resolver.resolve(IPokemonGridPresenter.self) else {
                    fatalError("Cannot resolve IPokemonGridPresenter")
                }
                let view = PokemonGridViewController(presenter: presenter)
                presenter.view = view
                return view
            }
    }

    private static func registerPokemonDetails(in container: Container) {
        container
            .register(IPokemonDetailsPresenter.self) { (resolver, pokemon: Pokemon) in
                guard let pokemonsService = resolver.resolve(IPokemonsService.self) else {
                    fatalError("Cannot resolve IPokemonsService")
                }
                guard let imageLoader = resolver.resolve(ImageLoading.self) else {
                    fatalError("Cannot resolve ImageLoading")
                }
                return PokemonDetailsPresenter(pokemon: pokemon, pokemonsService: pokemonsService, imageLoader: imageLoader)
            }

        container
            .register(IPokemonDetailsView.self) { (resolver, pokemon: Pokemon) in
                guard let presenter = resolver.resolve(IPokemonDetailsPresenter.self, argument: pokemon) else {
                    fatalError("Cannot resolve IPokemonDetailsPresenter")
                }
                let view = PokemonDetailsViewController(presenter: presenter)
                presenter.view = view
                return view
            }
    }

    private static func registerPokemonEvolutionGrid(in container: Container) {
        container
            .register(IPokemonEvolutionGridPresenter.self) { (resolver, details: PokemonDetails) in
                guard let pokemonsService = resolver.resolve(IPokemonsService.self) else {
                    fatalError("Cannot resolve IPokemonsService")
                }
                guard let imageLoader = resolver.resolve(ImageLoading.self) else {
                    fatalError("Cannot resolve ImageLoading")
                }
                return PokemonEvolutionGridPresenter(details: details, pokemonsService: pokemonsService, imageLoader: imageLoader)
            }

        container
            .register(IPokemonEvolutionGridView.self) { (resolver, details: PokemonDetails) in
                guard let presenter = resolver.resolve(IPokemonEvolutionGridPresenter.self, argument: details) else {
                    fatalError("Cannot resolve IPokemonEvolutionGridPresenter")
                }
                let view = PokemonEvolutionGridViewController(presenter: presenter)
                presenter.view = view
                return view
            }
    }
}
