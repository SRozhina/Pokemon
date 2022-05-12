import Foundation

enum PokemonImageUrlBuilder {
    static func makeUrl(for id: String) -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
    }
}
