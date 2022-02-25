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
    
    var firebaseManager = FirebaseManager()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.layer.cornerRadius = bodyTextView.frame.size.height/5
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
