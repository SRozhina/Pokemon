

import NeedleFoundation

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->ImageLoaderTestsDependenciesImpl") { component in
        return EmptyDependencyProvider(component: component)
    }
    
}

// MARK: - Providers

