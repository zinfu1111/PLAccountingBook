//
//  Network.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

enum ClientError: String, Error{
    case DataTaskError = "Please check your network connection."
}

enum NetworkErr: String, Error {
    //    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request."
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no date to decode."
    case unableToDecode = "We could not decode the response."
    case responseIsNil = "response is nil"
}

class Network: NSObject {
    static func Status(from response: HTTPURLResponse) -> Result<Int, NetworkErr>{
        switch response.statusCode {
        case 200...299: return .success(response.statusCode)
        case 401...500: return .failure(NetworkErr.authenticationError)
        case 501...599: return .failure(NetworkErr.badRequest)
        case 600: return .failure(NetworkErr.outdated)
        default: return .failure(NetworkErr.failed)
        }
    }
}
