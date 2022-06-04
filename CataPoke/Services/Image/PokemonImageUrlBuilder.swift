import Foundation

enum PokemonImageUrlBuilder {
    static func makeUrl(forPokemonId id: String) -> URL {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png") else {
            fatalError("Cannot create pokemon image url")
        }
        return url
    }
}
