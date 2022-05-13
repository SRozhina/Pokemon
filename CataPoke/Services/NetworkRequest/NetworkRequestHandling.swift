import Combine
import Foundation

// sourcery: AutoMockable
protocol NetworkRequestHandling {
    func getData(url: URL) -> AnyPublisher<Data, Error>
    func getData(request: URLRequest) -> AnyPublisher<Data, Error>
}
