//
//  HomeViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift


class HomeViewModel: NSObject {

    var tricounts = Variable<[Tricount]>([])
    
    func loadTricountData() {
        tricounts.value = Tricount.loadData()
    }
}
