enum PokemonDetailsFactory {
    static func makeDetails(_ speciesDetails: SpeciesDetails) -> PokemonDetails {
        PokemonDetails(
            name: speciesDetails.name,
            happinessRate: rate(Double(speciesDetails.baseHappiness), Constant.happinessMaximum),
            captureRate: rate(Double(speciesDetails.baseHappiness), Constant.captureMaximum),
            possibleGender: makeGender(from: speciesDetails.genderRate),
            specials: makeSpecials(from: speciesDetails),
            evolutionUrl: speciesDetails.evolutionChain.url
        )
    }

    private static func makeGender(from genderRate: Int) -> PokemonDetails.Gender {
        guard genderRate >= 0 else { return .genderless }
        let genderRate = Double(genderRate)
        if genderRate > Constant.genderMaximum / 2 {
            return .female(rate: rate(genderRate, Constant.genderMaximum))
        } else {
            let male = Constant.genderMaximum - genderRate
            return .male(rate: rate(male, Constant.genderMaximum))
        }
    }

    private static func makeSpecials(from speciesDetails: SpeciesDetails) -> [PokemonDetails.Special] {
        var specials: [PokemonDetails.Special] = []
        if speciesDetails.isBaby {
            specials.append(.baby)
        }
        if speciesDetails.isLegendary {
            specials.append(.legendary)
        }
        if speciesDetails.isMythical {
            specials.append(.mythical)
        }
        return specials
    }

    private static func rate(_ value: Double, _ max: Double) -> Int {
        Int(value / max * 100)
    }
}

private extension PokemonDetailsFactory {
    enum Constant {
        static let happinessMaximum: Double = 255
        static let captureMaximum: Double = 255
        static let genderMaximum: Double = 8
    }
}
