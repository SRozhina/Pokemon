import Combine
import Foundation

protocol NetworkRequestHandling {
    func getData(url: URL) -> AnyPublisher<Data, Error>
    func getData(request: URLRequest) -> AnyPublisher<Data, Error>
}
