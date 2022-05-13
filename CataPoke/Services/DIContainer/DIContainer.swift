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
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return PokemonRequestHandler(
                    requestHandling: resolver.resolve(NetworkRequestHandling.self)!,
                    decoder: decoder
                )
            }
            .inObjectScope(.container)

        container
            .register(IPokemonsService.self) { resolver in
                PokemonsService(requestHandler: resolver.resolve(PokemonRequestHandling.self)!)
            }
            .inObjectScope(.container)

        container
            .register(ImageCache.self) { _ in
                DefaultImageCache()
            }
            .inObjectScope(.container)

        container
            .register(ImageLoading.self) { resolver in
                ImageLoader(
                    requestHandling: resolver.resolve(NetworkRequestHandling.self)!,
                    cache: resolver.resolve(ImageCache.self)!
                )
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
                PokemonGridPresenter(
                    pokemonsService: resolver.resolve(IPokemonsService.self)!,
                    imageLoader: resolver.resolve(ImageLoading.self)!
                )
            }

        container
            .register(IPokemonGridView.self) { resolver in
                let presenter = resolver.resolve(IPokemonGridPresenter.self)!
                let view = PokemonGridViewController(presenter: presenter)
                presenter.view = view
                return view
            }
    }

    private static func registerPokemonDetails(in container: Container) {
        container
            .register(IPokemonDetailsPresenter.self) { (resolver, pokemon: Pokemon) in
                PokemonDetailsPresenter(
                    pokemon: pokemon,
                    pokemonsService: resolver.resolve(IPokemonsService.self)!,
                    imageLoader: resolver.resolve(ImageLoading.self)!
                )
            }

        container
            .register(IPokemonDetailsView.self) { (resolver, pokemon: Pokemon) in
                let presenter = resolver.resolve(IPokemonDetailsPresenter.self, argument: pokemon)!
                let view = PokemonDetailsViewController(presenter: presenter)
                presenter.view = view
                return view
            }
    }

    private static func registerPokemonEvolutionGrid(in container: Container) {
        container
            .register(IPokemonEvolutionGridPresenter.self) { (resolver, url: URL) in
                PokemonEvolutionGridPresenter(
                    url: url,
                    pokemonsService: resolver.resolve(IPokemonsService.self)!,
                    imageLoader: resolver.resolve(ImageLoading.self)!
                )
            }

        container
            .register(IPokemonEvolutionGridView.self) { (resolver, url: URL) in
                let presenter = resolver.resolve(IPokemonEvolutionGridPresenter.self, argument: url)!
                let view = PokemonEvolutionGridViewController(presenter: presenter)
                presenter.view = view
                return view
            }
    }
}
