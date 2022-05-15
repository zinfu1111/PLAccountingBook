//
//  SettingViewModel.swift
//  PLAccountingBook
//
//  Created by Paul on 2022/3/28.
//

import UIKit

class SettingViewModel: NSObject {
    
    private(set) var manager:RestManager!
    var logoutCompletion = {}
    
    override init() {
        super.init()
        manager = RestManager()
    }

    func uploadRecord(by memberId: Int,completion:@escaping(()->Void)) {
        let requsetGroup = DispatchGroup()
        let data = RecordManager.shared.query().map { item -> APIRequest.Create<Record>.Record in
            let record = Record(memberId: memberId, content: item.content, cost: item.cost, tag: item.tag, datetime: item.datetime)
            return APIRequest.Create<Record>.Record(fields: record)
        }
        
        let pushCount = data.count/9
        var currentIndex = 0
        for i in 1...pushCount {
            print("pushData\(i)",data[currentIndex...9*i])
            
            let currentData = data[currentIndex...9*i].map {  item -> APIRequest.Create<Record>.Record in
                return item
            }
            let postData = APIRequest.Create<Record>(records: currentData)
            requsetGroup.enter()
            postRecord(postData) {
                requsetGroup.leave()
            }
            currentIndex = 9*i+1
        }
        
        let losePushCount = data.count-currentIndex
        if losePushCount>0 {
            print("lastData",data[currentIndex...currentIndex+losePushCount-1])
            let currentData = data[currentIndex...currentIndex+losePushCount-1].map { item in
                return item
            }
            let postData = APIRequest.Create<Record>(records: currentData)
            requsetGroup.enter()
            postRecord(postData) {
                requsetGroup.leave()
            }

        }
        
        
        requsetGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func postRecord(_ postData: APIRequest.Create<Record>,completion:@escaping (()->Void)){
        
        manager.requestWAPI(.record, bodyParameters: postData, resType: APIResponse.List<Record>.self){[weak self] response, error in
            guard let weakSelf = self else { return }
            completion()

        }

    }
    
    func logout(){
        userId = ""
        UserDefaults.standard.removeObject(forKey: "UserId")
        logoutCompletion()
    }
}
