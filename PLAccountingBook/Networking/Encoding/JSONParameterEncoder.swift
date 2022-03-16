//
//  JSONParameterEncoder.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    ///
    /// - encode parameters to data
    /// - set data to http body
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws{
        do{
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
//            if urlRequest.value(forHTTPHeaderField: CONTENTTYPE) == nil{
//                urlRequest.setValue(APPLICATION_JSON, forHTTPHeaderField: CONTENTTYPE)
//            }
        }catch{
            throw CodingErr.encodingFailed
        }
    }
    
    ///
    /// - encode codable to data
    /// - set data to http body
    public static func encode(urlRequest: inout URLRequest, with codable: Encodable) throws {
        do {
            let data = try codable.encodeData()
            urlRequest.httpBody = data
//            if urlRequest.value(forHTTPHeaderField: CONTENTTYPE) == nil{
//                urlRequest.setValue(APPLICATION_JSON, forHTTPHeaderField: CONTENTTYPE)
//            }
        } catch {
            throw CodingErr.encodingFailed
        }
    }
}

