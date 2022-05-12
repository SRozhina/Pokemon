import Swinject

enum DIContainer {

    static func create() -> Container {
        let container = Container()

        container
            .register(RequestHandling.self) { _ in FakeRequestHandler() }
            .inObjectScope(.container)

        return container
    }
}
