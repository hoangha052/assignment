//
//  Tricount.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift

protocol PrimaryKeyAware {
    var title: String { get }
    static func primaryKey() -> String?
}

class RealmStorage<T: Object> where T: PrimaryKeyAware {
//    var realm: Realm
    
//    init() {
//        self.realm = reaml
//    }
    func save(_ objects: [T], realm: Realm, completed: (() -> Void)) {
        try? realm.write {
            realm.add(objects, update: true)
            completed()
        }
    }
}

@objcMembers
class Tricount: Object, PrimaryKeyAware {
    
    dynamic var title: String = ""
    let members = List<User>()
    let expenses = List<Expense>()
    
    static func loadData(realm: Realm) -> [Tricount] {
        realm.refresh()
        return realm.objects(self).compactMap({ $0 })
    }
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
