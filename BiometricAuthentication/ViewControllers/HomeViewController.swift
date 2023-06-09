//
//  HomeViewController.swift
//  BiometricAuthentication
//
//  Created by Zaid Sheikh on 08/06/2023.
//

import UIKit

class HomeViewController: UIViewController {

     var authentication: Authentication?
    
    @IBOutlet weak var logOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    

    @IBAction func logOut(_ sender: Any) {
        authentication?.updateValidation(success: false)
        self.dismiss(animated: true)
    }
    
    
}
