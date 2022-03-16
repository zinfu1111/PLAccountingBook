//
//  ParameterEncoding.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

public let CONTENTTYPE = "Content-Type"
public let APPLICATION_URL = "application/x-www-form-urlencoded; charset=utf-8"
public let APPLICATION_JSON = "application/json"

public typealias Parameters = [String: Any]
extension Parameters{
    static let boundary: String = "Boundary+\(arc4random())\(arc4random())"
}
public typealias StringParameters = String
public typealias URLParameters = [String: String]
public typealias EncodableParameters = Encodable

public enum CodingErr: String, Error{
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case decodingFailed = "Parameter decoding failed."
    case xmlDecodingFailed = "XML decoding failed."
    case missingURL = "URL is nil."
}

/// 為參數進行編碼，有錯誤將拋出。
public protocol ParameterEncoder{
    static func encode(urlRequest: inout URLRequest, with paramaters: URLParameters) throws
    static func encode(urlRequest: inout URLRequest, with paramaters: Parameters, dataParmaters: Parameters) throws
    static func encode(urlRequest: inout URLRequest, with Codable: EncodableParameters) throws
    static func encode(urlRequest: inout URLRequest, with string: StringParameters, encoding: String.Encoding) throws
}

extension ParameterEncoder{
    public static func encode(urlRequest: inout URLRequest, with parmaters: URLParameters) throws { fatalError("[Error] Encoding is empty.") }
    public static func encode(urlRequest: inout URLRequest, with parmaters: Parameters, dataParmaters: Parameters) throws{ fatalError("[Error] Encoding is empty.") }
    public static func encode(urlRequest: inout URLRequest, with Codable: EncodableParameters) throws { fatalError("[Error] Encoding is empty.") }
    public static func encode(urlRequest: inout URLRequest, with string: StringParameters, encoding: String.Encoding) throws { fatalError("[Error] Encoding is empty.") }
}
