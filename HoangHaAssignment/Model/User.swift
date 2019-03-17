//
//  User.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
class User: Object {

    dynamic var name: String = ""
    override class func primaryKey() -> String {
        return "name"
    }
}
