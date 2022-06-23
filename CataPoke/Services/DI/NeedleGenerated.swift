

import Foundation
import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->PokemonGridComponent->PokemonDetailsComponent") { component in
        return PokemonDetailsDependency4fee43a7127849cf57a6Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->PokemonGridComponent->PokemonDetailsComponent->PokemonEvolutionGridComponent") { component in
        return PokemonEvolutionGridDependency063917097a1feb55420fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->PokemonGridComponent") { component in
        return PokemonGridDependency57b3b3bb33841aafcf12Provider(component: component)
    }
    
}

// MARK: - Providers

private class PokemonDetailsDependency4fee43a7127849cf57a6BaseProvider: PokemonDetailsDependency {
    var imageLoader: ImageLoading {
        return rootComponent.imageLoader
    }
    var pokemonsService: IPokemonsService {
        return rootComponent.pokemonsService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->PokemonGridComponent->PokemonDetailsComponent
private class PokemonDetailsDependency4fee43a7127849cf57a6Provider: PokemonDetailsDependency4fee43a7127849cf57a6BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent.parent as! RootComponent)
    }
}
private class PokemonEvolutionGridDependency063917097a1feb55420fBaseProvider: PokemonEvolutionGridDependency {
    var imageLoader: ImageLoading {
        return rootComponent.imageLoader
    }
    var pokemonsService: IPokemonsService {
        return rootComponent.pokemonsService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->PokemonGridComponent->PokemonDetailsComponent->PokemonEvolutionGridComponent
private class PokemonEvolutionGridDependency063917097a1feb55420fProvider: PokemonEvolutionGridDependency063917097a1feb55420fBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent.parent.parent as! RootComponent)
    }
}
private class PokemonGridDependency57b3b3bb33841aafcf12BaseProvider: PokemonGridDependency {
    var imageLoader: ImageLoading {
        return rootComponent.imageLoader
    }
    var pokemonsService: IPokemonsService {
        return rootComponent.pokemonsService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->PokemonGridComponent
private class PokemonGridDependency57b3b3bb33841aafcf12Provider: PokemonGridDependency57b3b3bb33841aafcf12BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
