//
//  ExpensesViewController.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ExpensesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ExpensesViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationButton()
        self.bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadExpenseData()
    }
    
    private func bindingViewModel() {
        viewModel.expenses.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, element, cell) in
                guard self != nil else { return }
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = "PaidBy " + element.paidBy.name  + "-\(element.amount)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
//                self.performSegue(withIdentifier: "tricountDetailSegue", sender: self.viewModel.tricounts.value[indexPath.row])
            })
            .disposed(by: disposeBag)
        
    }

    private func setupNavigationButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(createExpense))
    }
    
    @objc private func createExpense() {
        self.performSegue(withIdentifier: "createExpenseSegue", sender: nil)
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
