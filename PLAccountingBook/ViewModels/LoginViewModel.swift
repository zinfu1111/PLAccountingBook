//
//  LoginViewModel.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/17.
//

import UIKit

class LoginViewModel: NSObject {

    typealias LoginSuccese = (APIResponse.List<Member>.Record)->Void
    typealias RegisterSuccese = (APIResponse.List<Member>.Record)->Void
    typealias ConnectError = ((String)->Void)
    
    private(set) var member:Member!
    var manager:RestManager!
    var loginSuccese:LoginSuccese?
    var registerSuccese:RegisterSuccese?
    var connectError:ConnectError?
    
    override init() {
        super.init()
        self.manager = RestManager()
        self.member = Member(name: "", point: 0, phone: "", mail: "")
    }
    
    func update(with member:Member) {
        self.member = member
    }
    
    func login(phone:String,mail:String){
        manager.requestJSONDataByURL(.member, nil, resType: APIResponse.List<Member>.self) {[weak self] responseData, error in
            guard let weakSelf = self else { return }
            guard let error = error else {
                
                if let data = responseData,let member = data.records.first(where: {$0.fields.phone == phone && $0.fields.mail == mail}) {
                    userId = member.id
                    weakSelf.loginSuccese?(member)
                }else{
                    weakSelf.register(phone: phone, mail: mail)
                }
                
                
                return
                
            }
            weakSelf.connectError?(error.localizedDescription)
        }
    }
    
    func register(phone:String,mail:String) {
        
        
        let member = Member(name: "test", point: 0, phone: phone, mail: mail)
        let postData = APIRequest.Create(records: [APIRequest.Create.Record(fields: member)])
        
        manager.requestWAPI(.member, bodyParameters: postData, resType: APIResponse.List<Member>.self){[weak self] response, error in
            guard let weakSelf = self else { return }
            guard let error = error,response == nil else {
                
                if let memeber = response?.records.first {
                    weakSelf.registerSuccese?(memeber)
                }
                return

            }
            weakSelf.connectError?(error.localizedDescription)
            
        }
        
    }
}
