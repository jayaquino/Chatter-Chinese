//
//  PostDetailsViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/23/22.
//

import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var postTitle: String?
    var postSender: String?
    var postVotes: Int?
    var postBody: String?
    var docID : String?
    private var firebaseManager = FirebaseManager()
    var delegate: isAbleToDeleteData?
    
    @IBAction func upvotePressed(_ sender: UIButton) {
        print("adding user")
        firebaseManager.addVoter(userID: firebaseManager.getUser(), documentID: docID!)
        firebaseManager.updateVoteAmount(documentID: docID!, sender: self)
    }
    
    @IBAction func downvotePressed(_ sender: UIButton) {
        print("removing voter")
        firebaseManager.removeVoter(userID: firebaseManager.getUser(), documentID: docID!)
        firebaseManager.updateVoteAmount(documentID: docID!, sender: self)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate!.pass(documentID: docID!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.layer.cornerRadius = bodyTextView.frame.size.height/5
        titleTextView.text = postTitle
        bodyTextView.text = postBody
        votesLabel.text = String(postVotes!)
        
        if firebaseManager.getUser() == postSender {
            print(true)
            deleteButton.alpha = 1
        } else {
            print(false)
            firebaseManager.addVoter(userID: postSender!, documentID: docID!)
        }
        
    }
}


