//
//  LoginRegisterViewController.swift
//  ChaChat
//
//  Created by Elnur Rzayev on 10/1/18.
//  Copyright © 2018 Elnur Rzayev. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


class LoginRegisterViewController: UIViewController{
   
    
    

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
  
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
//    LOGIN FUNCTION
    @IBAction func loginClicked(_ sender: UIButton) {
        
        if (!checkInput()){
            return
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                Utilities().showAlert(title: "Error!", message: error.localizedDescription , vc: self)
                print(error.localizedDescription)
                return
            }
            if (Auth.auth().currentUser != nil){
                self.dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier:  "ViewController")
                self.navigationController?.present(vc!, animated: true, completion: nil)
            }
            print("Signed in!")
        })
    }
    
//    CHECKING INPUT
//    !!!!!!!!!!!!!!!!!!!!!!!!1
    func checkInput() -> Bool {
        let strLength = emailTextField.text?.count
        if strLength! < 5{
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }else {
            emailTextField.backgroundColor = UIColor.white
        }
        let pswLength = passwordTextField.text?.count
        if pswLength! < 5{
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }else {
            passwordTextField.backgroundColor = UIColor.white
        }
        return true
    }
    
    
    
//    CHECKING INPUT END
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
  
    
    
    
//    REGISTRATION START
//    !!!!!!!!!!!!!!!!!!!!!!!!!
    @IBAction func registerClicked(_ sender: UIButton) {
        if (!checkInput()){
            return
        }
        
        let alert = UIAlertController(title: "Register", message: "Please confirm Password", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let passConfirm = alert.textFields![0] as UITextField
            if (passConfirm.text!.isEqual(self.passwordTextField.text!)){
//                registration Begins
                let email = self.emailTextField.text
                let password = self.passwordTextField.text
                
                Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                    if let error = error {
                        Utilities().showAlert(title: "Error", message: error.localizedDescription, vc: self)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }else {
                 Utilities().showAlert(title: "Error", message: "Passwords are not the same", vc: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
//    REGISTRATION END
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        if (!(emailTextField.text!.isEmpty)){
            let email = self.emailTextField.text
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                if let error = error {
                    Utilities().showAlert(title: "Error", message: error.localizedDescription, vc: self)
                    return
                }
                Utilities().showAlert(title: "Success", message: "Please check your email", vc: self)
            }
        }
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
