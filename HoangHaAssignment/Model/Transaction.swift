//
//  Transaction.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
class Transaction: Object {
    dynamic var userName: String = ""
    dynamic var amount: Double = 0
    
    static func getTotalAmount(transactions: [Transaction]) -> Double {
        return transactions.map({$0.amount}).reduce(0, +)
    }
    
    static func createTransaction(userName: String, amount: Double) -> Transaction {
        let transaction = Transaction()
        transaction.userName = userName
        transaction.amount = amount
        return transaction
    }
}
