//
//  Ext+Codable.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

extension String{
    /// 網址處理
    func urlEncoding() -> String{
        guard let string = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return ""
        }
        return string
    }
}

extension Data{
    /// [C] Use JSONSerialization.jsonObject()
    /// - default options = []
    public func toDic(options: JSONSerialization.ReadingOptions = []) -> Dictionary<String, Any>? {
        do{
            return try JSONSerialization.jsonObject(with: self, options: options) as? Dictionary<String, Any>
        }catch{
            print("[Error] Data isn't to Dictionary: \(error) _Ext+Decode")
        }
        return nil
    }
    
    public mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension Dictionary{
    /// Use JSONSerialization.data()
    /// - default options = []
    public func toData(options: JSONSerialization.WritingOptions = []) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        do {
            return try JSONSerialization.data(withJSONObject: self, options: options)
        } catch  {
            print("[Error] Dictionary isn't to Data: \(error) _Ext+Decode")
        }
        return nil
    }
    /// Use JSONSerialization.data()
    /// - default options = []
    public func toJSONString() -> String? {
        guard let data =  self.toData() else{ return nil }
        return String(data: data, encoding: .utf8)!.decodByJSON
    }
}

extension Encodable {
    /// encoding to Data
    public func encodeData() throws -> Data? {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
}

/// MARK: decoder
extension String{
    /// 網址處理
    func urlDecoding() -> String {
        guard let string = self.removingPercentEncoding else{
            return ""
        }
        return string
    }
    /// JSON URL "/" -> "\\/"
    var decodByJSON: String{
        return self.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}

extension Decodable {
    /// decoding Dictionary -> Data -> Struct(JSON)
    public static func decode(dic: Dictionary<AnyHashable, Any>) -> Self? {
        let decoder = JSONDecoder()
        do{
            return try decoder.decode(Self.self, from: dic.toData()!)
        }catch{
            print("[Error] JSON Dic Decoder faild: \(error) _Ext+Decode")
            return nil
        }
    }
    /// decoding Data -> JSON-Structure
    public static func decode(data: Data) -> Self? {
        let decoder = JSONDecoder()
        do{
            return try decoder.decode(Self.self, from: data)
        }catch{
            print("[Error] JSON Data Decoder faild: \(error) _Ext+Decode")
            return nil
        }
    }
    /// decoding -> JSON-Structure
    public static func decode(string: String) -> Self? {
        let decoder = JSONDecoder()
        do{
            guard let data = string.data(using: .utf8) else{
                print("[Error] JSON Decoder faild.")
                return nil
            }
            return try decoder.decode(Self.self, from: data)
        }catch{
            print("[Error] JSON Decoder faild.\n\(error)")
            return nil
        }
    }
}

