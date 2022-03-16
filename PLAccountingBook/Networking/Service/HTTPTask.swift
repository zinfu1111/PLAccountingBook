//
//  HTTPTask.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestWithParameters(bodyParameters: Parameters?,urlParameters: Parameters?)
    
    case requestWithParametersAndHeaders(bodyParameters: Parameters?
                           ,urlParameters: Parameters?
                           ,additionHeaders: HTTPHeaders)
    
    
    /// Use Dictionary encode/decode (body)
    case requestParameters(bodyParameters: Parameters?, urlParameters: URLParameters?)
    
    /// Use Json encode/decode (body)
    case requestCodable(bodyParameters: EncodableParameters? , urlParameters: URLParameters?)
    
    /// Use Format encode/decode (body)
    case requestIMGParameters(bodyParameters: Parameters? , urlParameters: URLParameters?, dataParameters: Parameters?)
}

