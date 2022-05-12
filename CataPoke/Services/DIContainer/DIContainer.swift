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
            .register(ImageLoading.self) { _ in
                ImageLoader()
            }
            .inObjectScope(.container)

        registerPokemonGrid(in: container)

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
                (presenter as? PokemonGridPresenter)?.view = view
                return view
            }
    }
}
