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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let database = Firestore.firestore()
    let locationManager = CLLocationManager()
    
    let firebaseManager = FirebaseManager()
    
    static var lat : Double = 0
    static var lon : Double = 0
    
    @IBAction func registerPressed(_ sender: UIButton) {
        // Brings the user to the registration form.
        locationManager.requestLocation()
        if let email = emailTextField.text, let password = passwordTextField.text  {
            firebaseManager.registerUser(email: email, password: password, segue: K.welcomeToRegisterSegue, sender: self)
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        // Check the textfield with the database. If the user exists and filled out the registration form, move to ChatView.
        // If the user did not fill out the registration form, return to the registration form.
        if let email = emailTextField.text, let password = passwordTextField.text {
            firebaseManager.signInUser(email: email, password: password, sender: self) { found in
                if found == true {
                    self.performSegue(withIdentifier: K.welcomeToChatSegue, sender: self)
                } else {
                    self.performSegue(withIdentifier: K.welcomeToRegisterSegue, sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in or Register"
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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

