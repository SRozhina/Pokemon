import Foundation

enum PokemonImageUrlBuilder {
    static func makeUrl(forPokemonId id: String) -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
    }
}
