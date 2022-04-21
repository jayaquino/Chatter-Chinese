//
//  ChatViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit
import Foundation
import Firebase
import CoreLocation
import MLKit
import NaturalLanguage
import IQKeyboardManagerSwift
import Popover
import K3Pinyin
import HanziPinyin
import CoreData

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    private let chineseModel = TranslateRemoteModel.translateRemoteModel(language: .chinese)
    private let englishModel = TranslateRemoteModel.translateRemoteModel(language: .english)
    private let firebaseManager = FirebaseManager()
    private let translationManager = TranslationManager()
    private let outputFormat = PinyinOutputFormat(toneType: .none, vCharType: .vCharacter, caseType: .lowercased)
    
    var data: [Message] = []
    var username: String = ""
    var language: String = ""
    var tabBarHeight: CGFloat?
    
    // Setup CoreData Items
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func sendPressed() {
        if messageTextField.text != "" {
            if let messageBody = messageTextField.text {
                firebaseManager.sendChat(messageBody: messageBody, messageSender: firebaseManager.getUser(), messageUsername: username, lat: WelcomeViewController.lat, lon:WelcomeViewController.lon ,sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarHeight = tabBarController?.tabBar.bounds.size.height ?? 0
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        // TableView Data Source
        tableView.dataSource = self
        tableView.delegate = self
        messageTextField.delegate = self
        tableView.register(UINib(nibName: K.messageCellNib, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Obtain messages array from the database
        firebaseManager.loadData(collection: K.FStore.messageCollectionName, lat:WelcomeViewController.lat, lon:WelcomeViewController.lon, sender: self)
        
        firebaseManager.getUsername(sender: self)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
    }
    
    // Long Press and Popover
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began && IQKeyboardManager.shared.keyboardShowing == false {
            let touchPoint = sender.location(in: tableView)
            let touchPoint2 = sender.location(in: self.view)
            print("touch 1: \(touchPoint) and touch2: \(touchPoint2)")
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                // Set dimensions
                let width = self.view.frame.width / 1.5
                let height = CGFloat(200)
                
                // Initialize UI elements
                let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: width/2, height: height))
                let textView = UITextView()
                
                // Set Label properties
                label.sizeToFit()
                label.numberOfLines = 0
                translationManager.translateLanguage(text: data[data.count - 1 - indexPath.row].body) { translatedText in
                    label.text = translatedText
                }
                label.textColor = .black
                label.textAlignment = .center
                label.font = UIFont(name: "Chalkboard SE", size: 15)
                
                // Set TextView properties
                textView.text = data[indexPath.row].body
                textView.layer.opacity = 0
                
                // Initialize Stack View and Button
                let stackView = UIStackView()
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: width/2, height: height))
                
                // Set Button properties
                button.setTitle(" Add ", for: .normal)
                button.backgroundColor = UIColor(named: "DarkGreen")
                button.layer.cornerRadius = button.frame.width/10
                button.addTarget(self, action: #selector(addSentence), for: .touchUpInside)
                
                // Set Stack View properties
                stackView.axis  = NSLayoutConstraint.Axis.vertical
                stackView.frame = aView.frame
                stackView.distribution  = UIStackView.Distribution.equalSpacing
                stackView.alignment = UIStackView.Alignment.center
                stackView.spacing = 15
                stackView.isLayoutMarginsRelativeArrangement = true
                stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                
                // Add UI elements to Stack View, add the Stack View to Popover View
                stackView.addArrangedSubview(label)
                stackView.addArrangedSubview(textView)
                stackView.addArrangedSubview(button)
                aView.addSubview(stackView)
                let options = [
                  .type(.up),
                  .animationIn(0.4),
                  .cornerRadius(height/4)
                  ] as [PopoverOption]
            
                let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
                popover.show(aView, point: touchPoint2)
            }
        }
    }
    
    // Save sentence to CoreData context
    func saveSentence() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    // Add Button function
    @objc func addSentence(sender: UIButton!) {
        // Get the context, prepare to add into the "staging area"
        sender.layer.opacity = 0
        let context = self.context

        // Create an alert
        var titleTextField = UITextField()
        let alert = UIAlertController(title: "Topic", message: "How can you use this sentence/word?", preferredStyle: .alert)
        // Create Text Field inside the alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Saying hello, ordering food/drinks, asking directions"
            titleTextField = alertTextField
            
        }
        
        //Create alert action
        let action = UIAlertAction(title: "Add item to study", style: .default) { action in
            // Add new category to the context
            let newSentence = Sentence(context: context)
            newSentence.title = titleTextField.text ?? "No Title"
            for aview in sender.superview!.subviews {
                if aview is UILabel {
                    let labelView = aview as! UILabel
                    let text = labelView.text!
                    newSentence.translated = text
                } else if aview is UITextView {
                    let textView = aview as! UITextView
                    let text = textView.text!
                    newSentence.sentence = text
                    // Save the edited context "staging area"
                }
            }
            self.saveSentence()
            }
        
        // Add the action to the alert
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Table View Data Source Methods
extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = data[data.count - 1 - indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        cell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count-1 {
            cell.pulse()
        }
    }
}

//MARK: - Table View Delegate Methods
extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        }
}

// MARK: - TextField Delegate Methods
extension ChatViewController: UITextFieldDelegate {
    // The IQKeyboardManager does not take into account the UITabManager. These methods adjust the layout constraint to move when the textfield is being edited.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let safeTabBarHeight = tabBarHeight {
            viewBottomConstraint.constant -= safeTabBarHeight
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let safeTabBarHeight = tabBarHeight {
            viewBottomConstraint.constant += safeTabBarHeight
            let indexPath = IndexPath(row: data.count-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendPressed()
        return true
    }
}

