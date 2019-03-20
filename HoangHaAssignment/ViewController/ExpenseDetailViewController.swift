//
//  ExpenseDetailViewController.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var paidByTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let pickerNameView = UIPickerView()
    let datePicker = UIDatePicker()
    let pickerTransactionView = UIPickerView()

    var viewMode: Bool = false
    var viewModel: ExpenseDetailViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindingView()
        if viewMode {
            self.view.isUserInteractionEnabled = false
            self.viewModel.loadViewModel()
        } else {
            setupNavigationButton()
            viewModel.date.value = Date()
        }
        bindingViewModel()
    }
    
    private func initView() {
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        paidByTextField.inputView = pickerNameView
        nameTextField.inputView = pickerTransactionView
    
    }
    
    private func bindingView() {
        datePicker.rx.controlEvent(.valueChanged).asObservable()
            .subscribe(onNext: { (_) in
                    self.viewModel.date.value = self.datePicker.date
            })
            .disposed(by: disposeBag)
        
        let userName = viewModel.getMemberList().map({ $0.name })
        Observable.just(userName)
            .bind(to: self.pickerNameView.rx.itemTitles) { _, element in
                return element
            }
            .disposed(by: disposeBag)
        
        
        Observable.just(userName)
            .bind(to: self.pickerTransactionView.rx.itemTitles) { _, element in
                return element
            }
            .disposed(by: disposeBag)
        
        pickerNameView.rx.itemSelected.asObservable()
            .bind { (row, component) in
                self.viewModel.paidBy.value = userName[row]
            }
        .disposed(by: disposeBag)
        
        pickerTransactionView.rx.itemSelected.asObservable()
            .bind { (row, component) in
                self.viewModel.transactionUserName.value = userName[row]
            }
            .disposed(by: disposeBag)
        
        titleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.expenseTitle)
            .disposed(by: disposeBag)
        
        moneyTextField.rx.text
            .orEmpty
            .subscribe(onNext: { text in
                self.viewModel.amount.value = Double(text) ?? 0
            })
            .disposed(by: disposeBag)
        

        let userNameValidation =
            nameTextField.rx.text
                .map { !$0!.isEmpty }
                .share(replay: 1)

        let amountValidation = moneyTextField
            .rx.text
            .map({!$0!.isEmpty})
            .share(replay: 1)

        let enableButton = Observable.combineLatest(userNameValidation, amountValidation) { (name, amount) in
            return name && amount
        }

        enableButton
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)

        addButton.rx.tap.do(onNext: { [weak self] in
            guard let self = self else { return }
            self.moneyTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
        }).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.addNewTransaction()
            self.viewModel.resetTransaction()
            self.addButton.isEnabled = false
            },onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    private func bindingViewModel() {
        viewModel.isSuccess
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showError()
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel.expenseTitle.asObservable()
            .subscribe(onNext: { [weak self] name in
                guard let self = self else { return }
                self.titleTextField.text = name
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel.date.asObservable()
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                self.dateTextField.text = date.timeToString(format: "dd/MM/YY")
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel.paidBy.asObservable()
            .subscribe(onNext: { [weak self] name in
                guard let self = self else { return }
                self.paidByTextField.text = name
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel.transactionUserName.asObservable()
            .subscribe(onNext: { [weak self] name in
                guard let self = self else { return }
                self.nameTextField.text = name
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel.amount.asObservable()
            .subscribe(onNext: { [weak self] amount in
                guard let self = self else { return }
                if amount == 0 {
                    self.moneyTextField.text = ""
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

        viewModel.totalAmount.asObservable()
            .subscribe(onNext: { [weak self] total in
                guard let self = self else { return }
                self.amountTextField.text = total == 0 ? "" : "$ \(total)"
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

        
        viewModel.transactionsObservable.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.textLabel?.text = element.userName
                if self.viewMode {
                    if self.viewModel.expense?.paidBy == element.userName {
                        if let amount = self.viewModel.expense?.amount {
                        cell.detailTextLabel?.text = "$\(amount -  element.amount)"
                        }
                    } else {
                        cell.detailTextLabel?.text = "$\(element.amount * -1)"
                    }
                } else {
                    cell.detailTextLabel?.text = "$\(element.amount)"
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePressed))
    }
    
    @objc private func savePressed() {
        viewModel.creatNewExpense()
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error!", message: "Please input full data", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
