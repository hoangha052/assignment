//
//  CreateTriCountViewController.swift
//  HoangHaAssignment
//
//  Created by Ha Ho on 3/16/19.
//  Copyright © 2019 Ha Ho. All rights reserved.
//

import UIKit

class CreateTriCountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNavigationButton()
    }
    
    private func setupNavigationButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePressed))
    }
    
    @objc private func savePressed() {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation t  

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
