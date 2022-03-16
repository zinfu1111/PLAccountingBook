//
//  FormatParameterEncoder.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

public struct FormatParameterEncoder: ParameterEncoder{
    /// - Parameters:
    /// ``` swift
    ///     "--\(boundary)\r\n"
    ///     "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
    ///     "\(value)\r\n"
    /// ```
    /// - DataParameters:
    /// ``` swift
    ///     "--\(boundary)\r\n"
    ///     "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n""
    ///     "Content-Type: image/png\r\n\r\n"
    ///     value
    ///     "\r\n"
    /// ```
    /// - End:
    /// ``` swift
    ///     "--\(boundary)--\r\n"
    /// ```
    public static func encode(urlRequest: inout URLRequest, with parmaters: Parameters, dataParmaters: Parameters) throws {
        var body = Data()
        let boundary = Parameters.boundary
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in parmaters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
            
        for (key, value) in dataParmaters {
            var data: Data? = nil
            if value is String{
                data = (value as! String).data(using: .utf8)
            }else{
                data = value as? Data
            }
            guard data != nil else{
                throw CodingErr.encodingFailed
            }
            body.appendString(string: "--\(boundary)\r\n")
            //此處放入file name，以隨機數代替，可自行放入
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n")
            //image/png 可改為其他檔案類型 ex: jpeg
            body.appendString(string: "Content-Type: image/jpeg\r\n\r\n")
            body.append(data!)
            body.appendString(string: "\r\n")
        }

        body.appendString(string: "--\(boundary)--\r\n")
        
        urlRequest.httpBody = body
    }
}
