//
//  MemberDiaryViewController.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MemberDiaryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MemberDiaryViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        loadData()
        bindingViewModel()
    }
    
    private func initView() {
        self.title = viewModel.user.name
    }
    
    private func loadData() {
        viewModel.getDiariesData()
    }
    
    private func bindingViewModel() {
        viewModel.dairies.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                let spended: Double = element.mePaided ? element.total - element.amount : element.amount * -1
                let dateTitle: String = element.date.toDateString() +  "-" + element.title + "\n"
                let spendedString: String = "You Spended " + "$\(spended)" + "\n "
                let withBill: String = "With bill " + "$ \(element.total) " + "\n"
                let youPaided: String = "You paided: " + self.boolToString(value: element.mePaided)
                cell.textLabel?.text = dateTitle + spendedString + withBill + youPaided
            }
            .disposed(by: disposeBag)
    }
    

    private func boolToString(value: Bool) -> String {
        return value ? "YES" : "NO"
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
