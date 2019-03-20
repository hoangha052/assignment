//
//  MemberDairyViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

struct Diary {
    var title: String = ""
    var date: Date = Date()
    var amount: Double = 0
    var total: Double = 0
    var mePaided: Bool = false
    
    init(title: String, date: Date, amount: Double, total: Double, mePaided: Bool) {
        self.title = title
        self.date = date
        self.amount = amount
        self.total = total
        self.mePaided = mePaided
    }
}
class MemberDiaryViewModel: NSObject {
    var tricount: Tricount!
    var user: User!
    var dairies = Variable<[Diary]>([])
    
    func getDiariesData() {
        let expenses = tricount.expenses.compactMap({ $0 })
        for item in expenses {
            let transcations = item.transactions.filter(NSPredicate(format: "userName = %@", self.user.name))
            if let transaction = transcations.first {
                let mePaided = (item.paidBy == user.name)
                let transactionAmount = transaction.amount
                let diaray: Diary = Diary(title: item.title, date: item.date,
                                          amount: transactionAmount,
                                          total: item.amount, mePaided: mePaided)
                dairies.value.append(diaray)
            }
        }
    }
}

