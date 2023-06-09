//
//  ViewController.swift
//  BiometricAuthentication
//
//  Created by Zaid Sheikh on 08/06/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var faceBtn: UIButton!
    
    private var loginVM = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img.image = UIImage(systemName: "lock.rectangle.stack.fill")
        self.img.tintColor = .black
        
        emailtxt.delegate = self
        passwordtxt.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func login(){
        emailtxt.resignFirstResponder()
        passwordtxt.resignFirstResponder()
        
        if emailtxt.text!.isEmpty{
            showAlert(title: "Error", message: "Please fill all fields")
        }else if passwordtxt.text!.isEmpty{
            showAlert(title: "Error", message: "Please fill all fields")
        }
        else{
            loginVM.credentials.email = emailtxt.text!
            loginVM.credentials.password = passwordtxt.text!
            loginVM.storeCredentialsNext = true
            
            loginVM.login { [ weak self ] success in
                guard success == true else{
                    return
                }
                Authentication.shared.updateValidation(success: success)
                
                self?.emailtxt.text = nil
                self?.passwordtxt.text = nil
                
                
                let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                let nav = UINavigationController(rootViewController: homeViewController)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.tintColor = .black
                self?.present(nav, animated: true)
            }
        }
    }
    
    
    @IBAction func loginAction(_ sender: Any){
        
        self.login()
        
    }
    
    @IBAction func faceIdBtn(_ sender: Any){
        if Authentication.shared.biometricType() != .none {
            Authentication.shared.requestBiometricUnlock { (result:Result<Credentials, Authentication.AuthenticationError>) in
                switch result {
                case .success(let credentials):
                    self.loginVM.credentials = credentials
                    self.loginVM.login { success in
                        Authentication.shared.updateValidation(success: success)
                        
                        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                        let nav = UINavigationController(rootViewController: homeViewController)
                        nav.modalPresentationStyle = .fullScreen
                        nav.navigationBar.tintColor = .black
                        self.present(nav, animated: true)
                    }
                case .failure(let error):
                    self.loginVM.error = error
                    print("Error in faceid: \(error)")
                    self.showAlert(title: "Error", message: "\(error)")
                }
            }
        }
    }
    
    func showAlert(title:String?, message:String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "Ok" , style: .default));
            self.present(alert, animated: true)
        }
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailtxt{
            passwordtxt.becomeFirstResponder()
        }
        else if textField == passwordtxt{
            login()
        }
        return true
    }
}

