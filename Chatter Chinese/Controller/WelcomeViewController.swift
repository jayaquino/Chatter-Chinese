//
//  ViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit
import Firebase
import CoreLocation

class WelcomeViewController: UIViewController {

    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginPressedOutlet: UIButton!
    
    private let database = Firestore.firestore()
    private let locationManager = CLLocationManager()
    private let firebaseManager = FirebaseManager()
    private let userDefaults = UserDefaults.standard
    
    static var lat : Double = 0
    static var lon : Double = 0
    
    @IBAction func registerPressed(_ sender: UIButton) {
        // Send the user to the registration form.
        locationManager.requestLocation()
        if let email = emailTextField.text, let password = passwordTextField.text  {
            
            // Userdefaults if the user currently exists, may replace with KeyChain
            userDefaults.set(email, forKey: "user")
            userDefaults.set(password, forKey: "pw")
            
            // Firebase manager to register the user
            firebaseManager.registerUser(email: email, password: password, segue: K.welcomeToRegisterSegue, sender: self)
        } else {
            
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        // Check the textfield with the database. If the user exists and filled out the registration form, move to ChatView.
        // If the user did not fill out the registration form, return to the registration form.
        sender.pulse()
        if let email = emailTextField.text, let password = passwordTextField.text {
            firebaseManager.signInUser(email: email, password: password, sender: self) { found in
                if found == true {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBar")
                       
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                } else {
                    self.performSegue(withIdentifier: K.welcomeToRegisterSegue, sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        title = "Sign in or Register"
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        // Set location manager delegate, request permission to obtain location, obtain location
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
        let user = userDefaults.object(forKey: "user") as? String
        let pw = userDefaults.object(forKey: "pw") as? String
        print("\(user), \(pw)")
//        if user != nil && pw != nil {
//            emailTextField.text = user
//            passwordTextField.text = pw
//            loginPressedOutlet.sendActions(for: .touchUpInside)
//        }
    }

}

extension WelcomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            print(location)
            locationManager.stopUpdatingLocation()
            WelcomeViewController.lat = location.coordinate.latitude
            WelcomeViewController.lon = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

