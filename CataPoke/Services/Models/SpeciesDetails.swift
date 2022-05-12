import Foundation

/// Species object returned as part of the `getSpeciesDetails` endpoint
struct SpeciesDetails: Codable {
    let name: String
    let baseHappiness: Int
    let captureRate: Int
    let genderRate: Int
    let isBaby: Bool
    let isLegendary: Bool
    let isMythical: Bool
    let evolutionChain: EvolutionChain
}

/// EvolutionChain model returned as part of the SpeciesDetails from the `getSpecies` endpoint
struct EvolutionChain: Codable {
    let url: URL
}
