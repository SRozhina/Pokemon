import Swinject

enum DIContainer {

    static func create() -> Container {
        let container = Container()

        container
            .register(RequestHandling.self) { _ in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return URLSessionRequestHandler(decoder: decoder)
            }
            .inObjectScope(.container)

        container
            .register(IPokemonsService.self) { resolver in
                PokemonsService(requestHandler: resolver.resolve(RequestHandling.self)!)
            }
            .inObjectScope(.container)

        container
            .register(ImageCache.self) { _ in
                DefaultImageCache()
            }
            .inObjectScope(.container)

        container
            .register(ImageLoading.self) { resolver in
                ImageLoader(cache: resolver.resolve(ImageCache.self)!)
            }
            .inObjectScope(.container)

        registerPokemonGrid(in: container)
        registerPokemonDetails(in: container)

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
}
