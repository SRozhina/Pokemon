import UIKit

struct Pokemon {
    let name: String
    let image: UIImage?
    let detailsUrl: URL
    let imageUrl: URL

    func with(image: UIImage?) -> Pokemon {
        Pokemon(
            name: name,
            image: image,
            detailsUrl: detailsUrl,
            imageUrl: imageUrl
        )
    }
}
