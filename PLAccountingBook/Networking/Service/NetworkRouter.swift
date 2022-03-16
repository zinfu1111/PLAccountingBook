//
//  NetworkRouter.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: AnyObject {
    /// [推斷型態] process any `EndPointType` type.
    /// - haven't `associatedtype`, `EndPointType` need init.
    associatedtype EndPoint: EndPointType
    
    /// Request function at Network (Certificate Authentica)
    func request(_ route: EndPoint, SSLEnable: Bool, cerFileName: String, completion: @escaping NetworkRouterCompletion)
    
    /// Request can cancel at any time in self lift cycle.
    func cancel()
}

