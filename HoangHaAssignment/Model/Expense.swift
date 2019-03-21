//
//  Expense.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
class Expense: Object, PrimaryKeyAware {
    dynamic var title: String = ""
    dynamic var amount: Double = 0
    dynamic var date: Date = Date()
    dynamic var paidBy: String = ""
    dynamic var transactions = List<Transaction>()
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

