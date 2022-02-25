//
//  WelcomeViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text  {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.chatSegue, sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
