//
//  CreateTricountViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class CreateTricountViewModel: NSObject{

    var isSuccess: Variable<Bool> = Variable(false)
    var tricountTitle = Variable<String>("")
    var userName = Variable<String>("")
    var members = Variable<[User]>([])
    var realm: Realm = try! Realm()
    
    lazy private(set) var userNameIsValid: Observable<Bool> = self.userName
        .asObservable()
        .map { name in
        return !name.isEmpty
    }
    
    var dataObservable: Observable<[User]> {
        return members.asObservable()
    }
    
    func addNewUser() {
        guard !checkUserDuplicateName(name: userName.value) else { return }
        let newUser = User(value: ["name": userName.value])
        members.value.append(newUser)
        userName.value = ""
    }
    
    private func checkUserDuplicateName(name: String) -> Bool {
        let user = members.value.filter { (user) -> Bool in
            return user.name == name
        }
        return user.count > 0
    }
    
    func userNameForItem(at indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < members.value.count else { return "" }
        return members.value[indexPath.row].name
    }
    
    func createTriCount() {
        guard !tricountTitle.value.isEmpty, members.value.count > 0 else { return }
        let newTricount = Tricount()
        newTricount.title = tricountTitle.value
        newTricount.members.append(objectsIn: members.value)
        
        let storage = RealmStorage<Tricount>()
        storage.save([newTricount], realm: realm) {
            self.isSuccess.value = true
        }
    }
    
}
