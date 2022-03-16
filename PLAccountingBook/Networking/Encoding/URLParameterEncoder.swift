//
//  URLParameterEncoder.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else{ throw CodingErr.missingURL }
        // URLComponents:
        // A structure that parses URLs into and constructs URLs from their constituent parts.
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            // QueryItems:
            // An array of query items for the URL in the order in which they appear in the original query string.
            urlComponents.queryItems = [URLQueryItem]()
            
            for (k, v) in parameters{
                let queryItem = URLQueryItem(name: k, value: "\(v)")
                urlComponents.queryItems?.append(queryItem)
                urlRequest.url = urlComponents.url
            }
        }
    }
    
}
