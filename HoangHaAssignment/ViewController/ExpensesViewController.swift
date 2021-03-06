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
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var balanceButton: UIButton!
    
    var viewModel: ExpensesViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationButton()
        self.bindingView()
        self.bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadExpenseData()
    }
    
    private func bindingView() {
        memberButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showMembersSegue", sender: self.viewModel.tricount)
            })
            .disposed(by: disposeBag)
        
        balanceButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showBalanceSegue", sender: self.viewModel.tricount)
            })
            .disposed(by: disposeBag)
    
    }
    
    private func bindingViewModel() {
        viewModel.expenses.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, element, cell) in
                guard self != nil else { return }
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = "Paid By: " + element.paidBy  + " with total $ \(element.amount)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "createExpenseSegue", sender: self.viewModel.expenses.value[indexPath.row])
            })
            .disposed(by: disposeBag)
        
    }

    private func setupNavigationButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(createExpense))
    }
    
    @objc private func createExpense() {
        self.performSegue(withIdentifier: "createExpenseSegue", sender: self.viewModel.tricount)
    }
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createExpenseSegue" {
            let viewController = segue.destination as! ExpenseDetailViewController
            viewController.viewModel = ExpenseDetailViewModel()
            if let tricount = sender as? Tricount {
                viewController.viewModel.tricount = tricount
            } else if let expense = sender as? Expense {
                viewController.viewModel.expense = expense
                viewController.viewMode = true
            }
        } else if segue.identifier == "showMembersSegue" {
            let viewController = segue.destination as! MembersViewController
            viewController.viewModel = MemberViewModel()
            viewController.viewModel.tricount = sender as? Tricount            
        } else if segue.identifier == "showBalanceSegue" {
            let viewController = segue.destination as! BalancesViewController
            viewController.viewModel = BalanceViewModel()
            viewController.viewModel.tricount = sender as? Tricount
        }
    }

}
