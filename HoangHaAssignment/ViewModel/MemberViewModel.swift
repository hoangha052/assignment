//
//  MemberViewModel.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/17/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class MemberViewModel: NSObject {
    var tricount: Tricount?
    var members = Variable<[User]>([])
    
    func loadMembers() {
        guard let tricount = tricount else {
            return
        }
        members.value = tricount.members.compactMap({ $0 })
    }
}
