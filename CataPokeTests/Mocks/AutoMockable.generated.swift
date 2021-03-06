// Generated using Sourcery 1.8.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine

@testable import CataPoke














class ImageCacheMock: ImageCache {

    //MARK: - getImage

    var getImageForCallsCount = 0
    var getImageForCalled: Bool {
        return getImageForCallsCount > 0
    }
    var getImageForReceivedUrl: URL?
    var getImageForReceivedInvocations: [URL] = []
    var getImageForReturnValue: UIImage?
    var getImageForClosure: ((URL) -> UIImage?)?

    func getImage(for url: URL) -> UIImage? {
        getImageForCallsCount += 1
        getImageForReceivedUrl = url
        getImageForReceivedInvocations.append(url)
        if let getImageForClosure = getImageForClosure {
            return getImageForClosure(url)
        } else {
            return getImageForReturnValue
        }
    }

    //MARK: - insertImage

    var insertImageForCallsCount = 0
    var insertImageForCalled: Bool {
        return insertImageForCallsCount > 0
    }
    var insertImageForReceivedArguments: (image: UIImage?, url: URL)?
    var insertImageForReceivedInvocations: [(image: UIImage?, url: URL)] = []
    var insertImageForClosure: ((UIImage?, URL) -> Void)?

    func insertImage(_ image: UIImage?, for url: URL) {
        insertImageForCallsCount += 1
        insertImageForReceivedArguments = (image: image, url: url)
        insertImageForReceivedInvocations.append((image: image, url: url))
        insertImageForClosure?(image, url)
    }

    //MARK: - removeImage

    var removeImageForCallsCount = 0
    var removeImageForCalled: Bool {
        return removeImageForCallsCount > 0
    }
    var removeImageForReceivedUrl: URL?
    var removeImageForReceivedInvocations: [URL] = []
    var removeImageForClosure: ((URL) -> Void)?

    func removeImage(for url: URL) {
        removeImageForCallsCount += 1
        removeImageForReceivedUrl = url
        removeImageForReceivedInvocations.append(url)
        removeImageForClosure?(url)
    }

}
class NetworkRequestHandlingMock: NetworkRequestHandling {

    //MARK: - getData

    var getDataUrlCallsCount = 0
    var getDataUrlCalled: Bool {
        return getDataUrlCallsCount > 0
    }
    var getDataUrlReceivedUrl: URL?
    var getDataUrlReceivedInvocations: [URL] = []
    var getDataUrlReturnValue: AnyPublisher<Data, Error>!
    var getDataUrlClosure: ((URL) -> AnyPublisher<Data, Error>)?

    func getData(url: URL) -> AnyPublisher<Data, Error> {
        getDataUrlCallsCount += 1
        getDataUrlReceivedUrl = url
        getDataUrlReceivedInvocations.append(url)
        if let getDataUrlClosure = getDataUrlClosure {
            return getDataUrlClosure(url)
        } else {
            return getDataUrlReturnValue
        }
    }

    //MARK: - getData

    var getDataRequestCallsCount = 0
    var getDataRequestCalled: Bool {
        return getDataRequestCallsCount > 0
    }
    var getDataRequestReceivedRequest: URLRequest?
    var getDataRequestReceivedInvocations: [URLRequest] = []
    var getDataRequestReturnValue: AnyPublisher<Data, Error>!
    var getDataRequestClosure: ((URLRequest) -> AnyPublisher<Data, Error>)?

    func getData(request: URLRequest) -> AnyPublisher<Data, Error> {
        getDataRequestCallsCount += 1
        getDataRequestReceivedRequest = request
        getDataRequestReceivedInvocations.append(request)
        if let getDataRequestClosure = getDataRequestClosure {
            return getDataRequestClosure(request)
        } else {
            return getDataRequestReturnValue
        }
    }

}
