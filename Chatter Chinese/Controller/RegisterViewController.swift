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
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var genderButton: UIButton!
    
    private let firebaseManager = FirebaseManager()
    private let languages = ["English", "Chinese"]
    private var selectedLanguage = "English"
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Female"{
            sender.setTitle("Male", for: UIControl.State.normal)
        } else {
            sender.setTitle("Female", for: UIControl.State.normal)
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        // Registers user data to the Firebase database. Perform the seguei in the meantime.
        if usernameTextField.text!.count != 0 && ageTextField.text!.count != 0 {
            sender.pulse()
            if let username = usernameTextField.text, let age = ageTextField.text {
                let ageInt = Int(age)!
                
                if usernameTextField.text?.count ?? 0 > 10 || usernameTextField.text?.count ?? 0 < 3 {
                    let alert = UIAlertController(title: "Notice", message: "Username must be between 3 and 10 characters", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                } else if ageInt >= 100 {
                    let alert = UIAlertController(title: "Notice", message: "Please enter a valid age", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                } else {
                    print("registering")
                    firebaseManager.registerUserInfo(username: username, age: age, gender: genderButton.titleLabel!.text!, language: selectedLanguage, sender: self, email: firebaseManager.getUser())
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Notice", message: "All fields must be filled out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UIPickerView delegate and data source
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

extension RegisterViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage = languages[row]
    }
}

extension RegisterViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}
