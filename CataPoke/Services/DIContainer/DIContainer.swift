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

        return container
    }
}
