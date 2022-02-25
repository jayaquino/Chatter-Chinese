//
//  PostDetailsViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/23/22.
//

import UIKit

class PostDetailsViewController: UIViewController {

    var postTitle: String?
    var postSender: String?
    var postVotes: Int?
    var postBody: String?
    var docID : String?
    
    var delegate: isAbleToDeleteData?
    
    var firebaseManager = FirebaseManager()
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var votesTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func upvotePressed(_ sender: UIButton) {
    }
    
    @IBAction func downvotePressed(_ sender: UIButton) {
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate!.pass(documentID: docID!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.layer.cornerRadius = bodyTextView.frame.size.height/5
        votesTextView.layer.cornerRadius = votesTextView.frame.size.height/5
        titleTextView.text = postTitle
        bodyTextView.text = postBody
        votesTextView.text = "\(postVotes!)"
        
        if firebaseManager.getUser() == postSender {
            print(true)
            deleteButton.alpha = 1
        } else {
            print(false)
            firebaseManager.addVoter(userID: postSender!, documentID: docID!)
        }
        firebaseManager.checkPostContainsUserVote(userID: postSender!, documentID: docID!)
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


