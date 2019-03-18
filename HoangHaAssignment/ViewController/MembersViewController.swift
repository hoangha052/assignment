//
//  MembersViewController.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MembersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MemberViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        loadData()
    }
    
    private func loadData() {
        viewModel.loadMembers()
    }
    
    private func bindingViewModel() {
        viewModel.members.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, element, cell) in
                guard self != nil else { return }
                cell.textLabel?.text = element.name
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showMemberDairySegue", sender: self.viewModel.members.value[indexPath.row])
            })
            .disposed(by: disposeBag)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
