import NeedleFoundation

protocol PokemonDetailsDependency: Dependency {
    var imageLoader: ImageLoading { get }
    var pokemonsService: IPokemonsService { get }
}
