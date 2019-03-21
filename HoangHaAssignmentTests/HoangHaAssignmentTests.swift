//
//  HoangHaAssignmentTests.swift
//  HoangHaAssignmentTests
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
import RealmSwift

@testable import HoangHaAssignment

class HoangHaAssignmentTests: XCTestCase {

    var createTricountViewModel: CreateTricountViewModel!
    var realm: Realm!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        createTricountViewModel = CreateTricountViewModel()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realm = try! Realm()
        createTricountViewModel.realm = realm

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        createTricountViewModel.userName.value = ""
        createTricountViewModel.tricountTitle.value = ""
        
    }

    func testCreateUser () {
        let testUser: User = User(value: ["name": "Hoang Ha"])
        createTricountViewModel.userName.value = "Hoang Ha"
        createTricountViewModel.addNewUser()
        do {
            let result = try createTricountViewModel.members.asObservable().toBlocking().first()
            XCTAssertEqual(result?.first?.name, testUser.name)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testCreateTriCount() {
        createTricountViewModel.isSuccess.value = false
        createTricountViewModel.userName.value = "Hoang Ha3"
        createTricountViewModel.addNewUser()
        createTricountViewModel.tricountTitle.value = "TEST2"
        createTricountViewModel.createTriCount()
        XCTAssertEqual(try! createTricountViewModel.isSuccess.asObservable().toBlocking().first(), true)
    }

    func testCreateTriCountSaveDataSuccess() {
        createTricountViewModel.userName.value = "Hoang Ha4"
        createTricountViewModel.addNewUser()
        createTricountViewModel.tricountTitle.value = "TEST3"
        createTricountViewModel.createTriCount()
        let tricount = Tricount.loadData(realm: self.realm)
        XCTAssertEqual(tricount.first?.title, "TEST3")
    }
    
    func testLoadTricountMemberFormViewModel() {
        let tricount = Tricount()
        tricount.title = "Member ViewModel"
        tricount.members.append(objectsIn: [User(value: ["name" : "Ha"]),
                                            User(value: ["name" : "Huyen"]),
                                            User(value: ["name": "Van"]),
                                            User(value: ["name": "Hoang"])])
        let storage = RealmStorage<Tricount>()
        storage.save([tricount], realm: realm) {
        }
        let memberViewModel = MemberViewModel()
        memberViewModel.tricount = Tricount.loadData(realm: self.realm).first
        memberViewModel.loadMembers()
        do {
            let result = try memberViewModel.members.asObservable().toBlocking().first()
            XCTAssertEqual(result?.last?.name, "Hoang")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLoadTricountMembersFormDataBase() {
        let newTricount = Tricount()
        newTricount.title = "Member Realm"
        newTricount.members.append(objectsIn: [User(value: ["name" : "Ha"]),
                                   User(value: ["name" : "Huyen"]), User(value: ["name": "Van"])])
        let storage = RealmStorage<Tricount>()
        storage.save([newTricount], realm: realm) {
        }
        
        let tricount = Tricount.loadData(realm: self.realm)
        XCTAssertEqual(tricount.first?.members.count, 3)
    }
    
    
    func testGetTotalAmount() {
        let viewModel = ExpenseDetailViewModel()
        let transaction1 = Transaction.createTransaction(userName: "transaction1", amount: 10)
        let transaction2 = Transaction.createTransaction(userName: "transaction2", amount: 30)
        let transaction3 = Transaction.createTransaction(userName: "transaction3", amount: 50)
        let transaction4 = Transaction.createTransaction(userName: "transaction4", amount: 70)
        viewModel.transactions = [transaction1, transaction2, transaction3, transaction4]
        XCTAssertEqual(viewModel.getTotalAmount(), 160)
    }
    
    
    func testCreateExpense() {
        let viewModel = ExpenseDetailViewModel()
        viewModel.isSuccess.value = false
        viewModel.realm = self.realm
        let transaction1 = Transaction.createTransaction(userName: "transaction1", amount: 10)
        let transaction2 = Transaction.createTransaction(userName: "transaction2", amount: 30)
        let transaction3 = Transaction.createTransaction(userName: "transaction3", amount: 50)
        let transaction4 = Transaction.createTransaction(userName: "transaction4", amount: 70)
        viewModel.transactions = [transaction1, transaction2, transaction3, transaction4]
        viewModel.paidBy.value = "Hoang Ha"
        viewModel.totalAmount.value = viewModel.getTotalAmount()
        viewModel.expenseTitle.value = "Create Expense"
        viewModel.creatNewExpense()
        XCTAssertEqual(try! viewModel.isSuccess.asObservable().toBlocking().first(), true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
        }
    }
    
}
