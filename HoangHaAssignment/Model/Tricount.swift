//
//  Tricount.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
class Tricount: Object {
    dynamic var title: String = ""
    let members = List<User>()
    let expenses = List<Expense>()
    
    
}

