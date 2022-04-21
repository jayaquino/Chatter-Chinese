//
//  AddPostViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/22/22.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    private var firebaseManager = FirebaseManager()
    var delegate: isAbleToReceiveData?
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        titleTextField.text = nil
        bodyTextView.text = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishPressed(_ sender: UIButton) {
        if let title = titleTextField.text, let body = bodyTextView.text{
            delegate!.pass(title: title, body: body, sender: firebaseManager.getUser())
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.layer.cornerRadius = bodyTextView.frame.size.height/5
    }
}
