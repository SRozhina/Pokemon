import Foundation
import NeedleFoundation

final class RootComponent: BootstrapComponent {
    var networkRequestHandler: NetworkRequestHandling {
        shared { URLSessionNetworkRequestHandler() }
    }

    var pokemonRequestHandler: PokemonRequestHandling {
        shared {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return PokemonRequestHandler(
                requestHandling: networkRequestHandler,
                decoder: decoder
            )
        }
    }

    var pokemonsService: IPokemonsService {
        shared {
            PokemonsService(requestHandler: pokemonRequestHandler)
        }
    }

    var imageCache: ImageCache {
        shared { DefaultImageCache() }
    }

    var imageLoader: ImageLoading {
        shared {
            ImageLoader(requestHandling: networkRequestHandler, cache: imageCache)
        }
    }

    var pokemonGridComponent: PokemonGridComponent {
        PokemonGridComponent(parent: self)
    }
}
