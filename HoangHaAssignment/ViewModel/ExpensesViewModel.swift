//
//  ExpensesViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ExpensesViewModel: NSObject {

    var tricount: Tricount?
    var expenses = Variable<[Expense]>([])
    
    func loadExpenseData() {
        guard let tricount = tricount else {
            return
        }
        expenses.value = tricount.expenses.compactMap({ $0 })
    }
}
