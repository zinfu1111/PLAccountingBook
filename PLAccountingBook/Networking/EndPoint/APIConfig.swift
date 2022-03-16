//
//  APIConfig.swift
//  DemoNetworkLayer
//
//  Created by Paul on 2022/3/15.
//

import Foundation

enum Environment: String {
//    case local = ""
//    case dev = "https://api.airtable.com/v0/apphC2VdXkwsSgwVS"
    case product = "https://api.airtable.com/v0/appgmB2HPirKgnkeN"
}

enum APIMethod: String {
    case record = "/Record"
    case member = "/Member"
    case savingType = "/savingType"
    
    case product = "/Product"
}
