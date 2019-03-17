//
//  CreateTriCountViewController.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateTriCountViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userTableView: UITableView!
    
    var disposeBag = DisposeBag()
    let viewModel = CreateTricountViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationButton()
        self.bindingView()
    }
    
    private func bindingView() {
        viewModel.isSuccess
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.tricountTitle)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: disposeBag)
        
        viewModel.userNameIsValid
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(onNext: viewModel.addNewUser)
            .disposed(by: disposeBag)
        
        viewModel.userName.asObservable()
            .subscribe(onNext: { [weak self] (text) in
                guard let self = self else { return }
                self.nameTextField.text = text
            })
            .disposed(by: disposeBag)
        
        viewModel.dataObservable
            .bind(to: userTableView.rx.items(cellIdentifier: "MemberCell", cellType: UITableViewCell.self)) { [weak self] (row, element, cell) in
                guard self != nil else { return }
                cell.textLabel?.text = element.name
        }
            .disposed(by: disposeBag)        
    }
    
    private func setupNavigationButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePressed))
    }
    
    @objc private func savePressed() {
        viewModel.createTriCount()
    }
}
