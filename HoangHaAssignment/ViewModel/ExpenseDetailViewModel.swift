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
        var transaction: Transaction
        if let index = transactions.firstIndex(where: { (item) -> Bool in
            return item.userName == transactionUserName.value
        }) {
            transaction = transactions[index]
            transaction.amount = amount.value
            reloadTransactions()
        } else {
            transaction = Transaction()
            transaction.userName = transactionUserName.value
            transaction.amount = amount.value
            transactions.append(transaction)
            transactionsObservable.value.append(transaction)
        }
        totalAmount.value = self.getTotalAmount()
    }
    
    func reloadTransactions() {
        transactionsObservable.value = []
        transactionsObservable.value.append(contentsOf: transactions)
    }
    
    func resetTransaction() {
        transactionUserName.value = ""
        amount.value = 0
    }
    
    func creatNewExpense() {
        guard !expenseTitle.value.isEmpty, totalAmount.value != 0, !paidBy.value.isEmpty else { return }
        saveTransaction()
        let expense = Expense()
        expense.title = expenseTitle.value
        expense.amount = totalAmount.value
        expense.date = date.value
        expense.paidBy = paidBy.value
        expense.transactions.append(objectsIn: transactions)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(expense)
            tricount?.expenses.append(expense)
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
}
