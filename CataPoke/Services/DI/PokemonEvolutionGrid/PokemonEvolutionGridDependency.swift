import NeedleFoundation

protocol PokemonEvolutionGridDependency: Dependency {
    var imageLoader: ImageLoading { get }
    var pokemonsService: IPokemonsService { get }
}
