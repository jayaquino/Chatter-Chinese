//
//  WelcomeViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    let firebaseManager = FirebaseManager()
    
    @IBAction func registerPressed(_ sender: UIButton) {
        // Registers user data to the Firebase database. Perform the seguei in the meantime.
        
        if let username = usernameTextField.text, let age = ageTextField.text , let gender = genderTextField.text {
            firebaseManager.registerUserInfo(username: username, age: age, gender: gender, sender: self, email: firebaseManager.getUser())
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
