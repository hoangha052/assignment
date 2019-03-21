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
    var expense: Expense?
    var isSuccess: Variable<Bool> = Variable(false)
    var expenseTitle = Variable<String>("")
    var paidBy = Variable<String>("")
    var date =  Variable<Date>(Date())
    var totalAmount = Variable<Double>(0)
    var transactions = [Transaction]()
    var transactionUserName = Variable<String>("")
    var amount = Variable<Double>(0)
    var transactionsObservable = Variable<[Transaction]>([])
    var realm = try! Realm()
    
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
        guard !expenseTitle.value.isEmpty, totalAmount.value != 0, !paidBy.value.isEmpty else {
            isSuccess.value = false
            return
        }
        saveTransaction()
        let expense = Expense()
        expense.title = expenseTitle.value
        expense.amount = totalAmount.value
        expense.date = date.value
        expense.paidBy = paidBy.value
        expense.transactions.append(objectsIn: transactions)
        
        let storage = RealmStorage<Expense>()
        storage.save([expense], realm: self.realm) {
            tricount?.expenses.append(expense)
            self.isSuccess.value = true
        }
    }
    
    func loadViewModel() {
        guard let expense = expense else {
            return
        }
        expenseTitle.value = expense.title
        paidBy.value = expense.paidBy
        date.value = expense.date
        totalAmount.value = expense.amount
        transactions = expense.transactions.compactMap({ $0 })
        transactionsObservable.value.append(contentsOf: transactions)
    }
    
    private func saveTransaction() {
        for item in transactions {
            if item.userName == paidBy.value {
                item.amount = totalAmount.value - item.amount
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
        return Transaction.getTotalAmount(transactions: transactions)
    }
    
    func getMemberList() -> [User] {
        return tricount?.members.compactMap({ $0 }) ?? []
    }
}
