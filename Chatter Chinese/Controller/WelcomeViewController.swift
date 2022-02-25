//
//  ViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    
    
    @IBAction func chatPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.userSegue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

