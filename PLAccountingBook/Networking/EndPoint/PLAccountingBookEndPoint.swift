//
//  PLAccountingBookEndPoint.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

enum PLAccountingBookEndPoint{
    
    case getJSONData(path: APIMethod,urlParameters: URLParameters? = nil)
    
    case WSURLJSON(path: APIMethod, bodyParameters: Parameters)
    
    /// webservice
    ///
    /// - Header: ["Content-Type”: "application/json"]
    /// - Method: POST
    /// - Request: JSON-Data (body)
    ///     - ["parameter1": "value", "parameter2": "value"]
    ///     - Struct (JSONEncoder/JSONDecoder)
    /// - Response: JSON
    case WAPI(path: APIMethod, body: EncodableParameters,method: HTTPMethod = .post)
    
    /// webservice
    ///
    /// - Header: ["Content-Type”: "application/json"]
    /// - Method: POST
    /// - Request: JSON-Data (body)
    ///     - ["parameter1": "value", "parameter2": "value"]
    ///     - Struct (JSONEncoder/JSONDecoder)
    /// - Response: JSON
    case formData(path: APIMethod, Parameters: Parameters, DataParameters: Parameters)
}
extension PLAccountingBookEndPoint: EndPointType{
    var baseURL: URL {
        guard let url = URL(string: RestManager.environment.rawValue) else {
            fatalError("[Warning] baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .WSURLJSON(let path, _):
            return path.rawValue
        case .WAPI(path: let path, body: _,_):
            return path.rawValue
        case .formData(path: let path, _, _):
            return path.rawValue
        case .getJSONData(path: let path, _):
            return path.rawValue
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .WSURLJSON(_, _):
            return .post
        case .WAPI(path: _, body: _,let method):
            return method
        case .formData:
            return .post
        case .getJSONData(path: _, _):
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getJSONData(_, urlParameters: let urlParameters):
            return .requestWithParameters(bodyParameters: nil, urlParameters: urlParameters)
        case .WSURLJSON(_, let bodyParameters):
            return .requestParameters(bodyParameters: bodyParameters, urlParameters: nil)
        case .WAPI(path: _, body: let body,_):
            return .requestCodable(bodyParameters: body, urlParameters: nil)
        case .formData(_, Parameters: let Parameters, DataParameters: let DataParameters):
            return .requestIMGParameters(bodyParameters: Parameters, urlParameters: nil, dataParameters: DataParameters)
        }
    }
    
    var headers: HTTPHeaders? {
        let defaultHeader = [
            "Authorization": "Bearer keyk9UtV73WZD5WkQ",
            "Content-Type": "application/json",
            "Charset": "utf-8",
            "CC-Type":"phone"
        ]
        return defaultHeader
    }
}
