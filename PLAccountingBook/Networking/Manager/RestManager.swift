//
//  RestManager.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation
typealias completionJSON<T: Codable> = (_ response: T?,_ error: Error?)->()
struct RestManager{
    static let environment: Environment = .product
    
    let router = Router<PLAccountingBookEndPoint>()
    
    func requestJSONDataByURL<T: Codable> (
            _ path: APIMethod,
            _ urlParameters: URLParameters? = nil,
            resType: T.Type,
            completion: @escaping completionJSON<T>) {
//        print("[API] Request Data: \(bodyParameters)")
                router.request(.getJSONData(path: path, urlParameters: urlParameters)) {
            (data, res, error) in
            if let data = data {
                print("[API] Response before decoder: \(String(describing: String(data: data, encoding: .utf8)))")
            }else{
                print("[API] Response error: \(String(describing: error))")
            }
            do{
                let data = try self.responseFilter(data, res, error)
                guard let res = T.decode(data: data) else{
                    throw CodingErr.decodingFailed
                }
//                print("[API] Response: \(res)")
                completion(res, nil)
            }catch{
                completion(nil, error)
            }
        }
    }
    
    /// webservice
    ///
    /// - Parameters:
    ///   - path: URL Method
    ///   - urlParameter: set request url parametersd
    ///   - resType: response type (JSON-Structure)
    ///   - completion: handle after get response
    ///   - response: response JSON-Structure
    ///   - error: client. request. decode/encode error
    func requestWSURLJSON<U: Codable> (
        _ path: APIMethod,
        bodyParameter: [String: Any],
        resType: U.Type,
        completion: @escaping completionJSON<U> ) {
            print("[API] Request Data: \(bodyParameter)")
            router.request(.WSURLJSON(path: path, bodyParameters: bodyParameter)) { (data, res, error) in
                do{
                    let data = try self.responseFilter(data, res, error)
                    if let res = U.decode(data: data){
                        print("[API] Response: \(res)")
                        completion(res, nil)
                    }else{
                        throw CodingErr.decodingFailed
                    }
                }catch{
                    completion(nil, error)
                }
            }
    }
    
    /// webservice
    ///
    /// - Parameters:
    ///   - path: URL Path
    ///   - bodyParameters: set request body parametersd
    ///   - resType: response type (JSON-Structure)
    ///   - completion: handle after get response
    ///   - response: response JSON-Structure
    ///   - error: client. request. decode/encode error
    func requestWAPI<T: Codable> (
            _ path: APIMethod,
            _ method: HTTPMethod = .post,
            bodyParameters: EncodableParameters,
            resType: T.Type,
            completion: @escaping completionJSON<T>) {
//        print("[API] Request Data: \(bodyParameters)")
        router.request(.WAPI(path: path, body: bodyParameters,method: method)) {
            (data, res, error) in
            if let data = data {
                print("[API] Response before decoder: \(String(describing: String(data: data, encoding: .utf8)))")
            }else{
                print("[API] Response error: \(String(describing: error))")
            }
            do{
                let data = try self.responseFilter(data, res, error)
                guard let res = T.decode(data: data) else{
                    throw CodingErr.decodingFailed
                }
//                print("[API] Response: \(res)")
                completion(res, nil)
            }catch{
                completion(nil, error)
            }
        }
    }
    
    /// Face Request with Form data
    ///
    /// - Parameters:
    ///   - path: URL  path
    ///   - Parameters: Configuretion Parameters
    ///   - DataParameters: UIImage
    ///   - resType: response JSON-Structure
    ///   - completion: client. request. decode/encode error
    func requestWithFormData<U: Codable> (
            _ path: APIMethod,
            parameters: Parameters,
            dataParameters: Parameters,
            resType: U.Type,
            completion: @escaping completionJSON<U> ) {
//        print("[API] Request Data: \(dataParameters)")
        router.request(.formData(path: path, Parameters: parameters, DataParameters: dataParameters)) {
            (data, res, error) in
            do{
                let data = try self.responseFilter(data, res, error)
                
                guard let res = U.decode(data: data) else{
                    throw CodingErr.decodingFailed
                }
//                print("[API] Response: \(res)")
                completion(res, nil)
//                if let data = resType.decode(data: data){
////                }else if let reqErr = FaceResErrMsg.decode(data: data){   // Same response of message and code
////                    completion(nil, ResponseError.ErrorMessage(reqErr.error_message))
//                }else{
//                    fatalError("Error Decoder Response")
//                }
            }catch{
                completion(nil, error)
            }
        }
    }
    
    /// This function handles exception errors
    ///  - Success:
    ///  `data: T?`
    ///  - Error:
    /// ```
    ///  error == nil [ClientError.DataTaskError]
    ///  response == nil || response != HTTPURLResponse [NetworkErr.responseIsNil]
    ///  data == nil [NetworkErr.noData]
    ///  Network.Status(from: res) == .failure(let error) [error]
    /// ```
    private func responseFilter<T>(_ data: T?, _ response: URLResponse?, _ error: Error?) throws -> T {
        guard error == nil else{
            throw ClientError.DataTaskError
        }
        guard let res = response as? HTTPURLResponse else{
            throw NetworkErr.responseIsNil
        }
        let result = Network.Status(from: res)
        switch result{
        case .success(_):
            guard let data = data else{
                throw NetworkErr.noData
            }
            return data
        case .failure(let error):
            throw error
        }
    }
}
