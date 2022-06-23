import NeedleFoundation

protocol PokemonGridDependency: Dependency {
    var imageLoader: ImageLoading { get }
    var pokemonsService: IPokemonsService { get }
}
