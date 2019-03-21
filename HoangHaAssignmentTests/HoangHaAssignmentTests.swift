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

    var homeViewModel: HomeViewModel!
    var createTricountViewModel: CreateTricountViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeViewModel = HomeViewModel()
        createTricountViewModel = CreateTricountViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()
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
        do{
            let result = try createTricountViewModel.members.asObservable().toBlocking().first()
            XCTAssertEqual(result?.first?.name, testUser.name)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testCreateTripCount() {
        createTricountViewModel.isSuccess.value = false
        createTricountViewModel.userName.value = "Hoang Ha3"
        createTricountViewModel.addNewUser()
        createTricountViewModel.tricountTitle.value = "TEST2"
        createTricountViewModel.createTriCount()
        XCTAssertEqual(try! createTricountViewModel.isSuccess.asObservable().toBlocking().first(), true)
    }

    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
