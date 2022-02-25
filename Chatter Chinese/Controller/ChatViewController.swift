//
//  ChatViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit
import Firebase
import CoreLocation

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let firebaseManager = FirebaseManager()

    var data: [Message] = []
    var username: String = ""
    
    @IBAction func chatPressed(_ sender: UIButton) {
       
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.chatToPost, sender: self)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextField.text != "" {
            if let messageBody = messageTextField.text {
                firebaseManager.sendChat(messageBody: messageBody, messageSender: firebaseManager.getUser(), messageUsername: username, lat: WelcomeViewController.lat, lon:WelcomeViewController.lon ,sender: self)
            }
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
            print("This is the Chat Controller")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        // TableView Data Source
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.messageCellNib, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Obtain messages array from the database
        firebaseManager.loadData(collection: K.FStore.messageCollectionName, lat:WelcomeViewController.lat, lon:WelcomeViewController.lon, sender: self)
        firebaseManager.getUsername(sender: self)
        
    }

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
}

//MARK: - UITABLEViewDataSource

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 20 {
            return 20
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftLabel.isHidden = true
            cell.leftBubble.isHidden = true
            cell.label.textAlignment = NSTextAlignment.right
        } else {
            cell.leftLabel.isHidden = false
            cell.leftBubble.isHidden = false
            cell.label.textAlignment = NSTextAlignment.left
            cell.leftLabel.text = message.username
        }
        return cell
    }
}

