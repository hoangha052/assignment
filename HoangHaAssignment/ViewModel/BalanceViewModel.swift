//
//  BalanceViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

struct Balance {
    var title: String = ""
    var amount: Double = 0
    init(title: String, amount: Double) {
        self.title = title
        self.amount = amount
    }
}

class BalanceViewModel: NSObject {
    
    var tricount: Tricount!
    var balances = Variable<[Balance]>([])
    
    func getAllBalance() {
        let expenses = tricount.expenses.compactMap({ $0 })
        let members = tricount.members.compactMap({ $0 })
        var tempTransactions = [Transaction]()
        for user in members {
            let tempTransaction = Transaction()
            tempTransaction.userName = user.name
            for item in expenses {
                let transcations = item.transactions.filter(NSPredicate(format: "userName = %@", user.name))
                tempTransaction.amount = tempTransaction.amount + Transaction.getTotalAmount(transactions: transcations.compactMap({$0}))
            }
            tempTransactions.append(tempTransaction)
        }
        compareBalance(transactions: tempTransactions)
    }
    
    private func compareBalance(transactions: [Transaction]) {
        let nagativeTransactions = transactions.filter({$0.amount < 0}).sorted {
            return $0.amount < $1.amount }
        let positiveTransactions = transactions.filter({$0.amount > 0}).sorted {return $0.amount > $1.amount}
        filterBalanceData(nagitiveTransaction: nagativeTransactions, positiveTransaction: positiveTransactions)
    }
    
    private func filterBalanceData(nagitiveTransaction: [Transaction], positiveTransaction: [Transaction]) {
        if nagitiveTransaction.count == 0 || positiveTransaction.count == 0 {
            return
        }
        var nagativeAmounts = nagitiveTransaction
        var positiveAmounts = positiveTransaction
        let result = createBalanceItem(nagative: nagativeAmounts.first!, positive: positiveAmounts.first!)
        nagativeAmounts.removeFirst()
        positiveAmounts.removeFirst()
        if result.overBalance > 0 {
            let newTransaction = Transaction.createTransaction(userName: result.userName, amount: result.overBalance)
            positiveAmounts.append(newTransaction)
            positiveAmounts = positiveAmounts.sorted { return $0.amount > $1.amount }
            print("positive ---\(positiveAmounts.count)")
        } else if result.overBalance < 0 {
            let newTransaction = Transaction.createTransaction(userName: result.userName, amount: result.overBalance)
            nagativeAmounts.append(newTransaction)
            nagativeAmounts = nagativeAmounts.sorted { return $0.amount < $1.amount }
            print("nagative ---\(nagativeAmounts.count)")
        }
        balances.value.append(result.balance)
        filterBalanceData(nagitiveTransaction: nagativeAmounts, positiveTransaction: positiveAmounts)
    }
    
    func createBalanceItem(nagative: Transaction, positive: Transaction) -> (balance: Balance, overBalance: Double, userName: String) {
        let oweString: String = nagative.userName.uppercased() + " owes " + positive.userName.uppercased()
        if nagative.amount + positive.amount > 0 {
            print("1 nợ 2 -- \(abs(nagative.amount))")
            return (Balance(title: oweString, amount: abs(nagative.amount)), nagative.amount + positive.amount, positive.userName)
        } else if nagative.amount + positive.amount < 0 {
            print("1 nợ 2 -- \(abs(positive.amount))")
            return (Balance(title: oweString, amount: positive.amount), nagative.amount + positive.amount, nagative.userName)
        }
        return (Balance(title: oweString, amount: positive.amount), 0, "")
    }
}


