//
//  ExpenseDetailViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

class ExpenseDetailViewModel: NSObject {
    
    var tricount: Tricount?
    var isSuccess: Variable<Bool> = Variable(false)
    var expenseTitle = Variable<String>("")
    var paidBy = Variable<String>("")
    var date =  Variable<Date>(Date())
    var totalAmount = Variable<Double>(0)
    var transactions = [Transaction]()
    var transactionUserName = Variable<String>("")
    var amount = Variable<Double>(0)
    var transactionsObservable = Variable<[Transaction]>([])
    
    func addNewTransaction() {
        let transaction = Transaction()
        transaction.userName = transactionUserName.value
        transaction.amount = amount.value
        transactions.append(transaction)
        transactionsObservable.value.append(transaction)
    }
    
    
    
    func creatNewExpense() {
        saveTransaction()
        let expense = Expense()
        expense.title = expenseTitle.value
        expense.amount = self.getTotalAmount()
        expense.date = date.value
        expense.paidBy = paidBy.value
        expense.transactions.append(objectsIn: transactions)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(expense)
            self.isSuccess.value = true
        }
    }
    
    private func saveTransaction() {
        for item in transactions {
            if item.userName == paidBy.value {
                item.amount = getTotalAmount() - item.amount
            } else {
                item.amount = item.amount * (-1)
            }
            let realm = try! Realm()
            try! realm.write {
                realm.add(item)
            }
        }
    }
    
    func getTotalAmount() -> Double {
        return transactions.map({$0.amount}).reduce(0, +)
    }
    
    func getMemberList() -> [User] {
        return tricount?.members.compactMap({ $0 }) ?? []
    }
    
//
//    func userNameForItem(at indexPath: IndexPath) -> String {
//        guard indexPath.row >= 0 && indexPath.row < members.value.count else { return "" }
//        return members.value[indexPath.row].name
//    }
//
//    func createTriCount() {
//        guard !tricountTitle.value.isEmpty, members.value.count > 0 else { return }
//        let newTricount = Tricount()
//        newTricount.title = tricountTitle.value
//        newTricount.members.append(objectsIn: members.value)
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(newTricount)
//            self.isSuccess.value = true
//        }
//    }

}
