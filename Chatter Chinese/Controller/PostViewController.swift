//
//  PostViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/20/22.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var firebaseManager = FirebaseManager()
    var data : [Post] = [
        Post(sender: "me", title: "things about me", body: "my body", votes: 3, id: "123"),
        Post(sender: "you", title: "things about you", body: "your body", votes: 6, id: "123")]
    
    @IBAction func addPostPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.postToAddPost, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        // Set data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.postCellNib, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        firebaseManager.loadPostData(collection: K.FStore.postCollectionName, lat: WelcomeViewController.lat, lon: WelcomeViewController.lon, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.postToAddPost {
            let destinationVC = segue.destination as! AddPostViewController
                destinationVC.delegate = self
        }
        if segue.identifier == K.postToPostDetails {
            let destinationVC = segue.destination as! PostDetailsViewController
            let row = (sender as! NSIndexPath).row;
            destinationVC.postTitle = data[row].title
            destinationVC.postBody = data[row].body
            destinationVC.postVotes = data[row].votes
            destinationVC.postSender = data[row].sender
            destinationVC.docID = data[row].id
            destinationVC.delegate = self
        }
    }
}

//MARK: - Table View Data Source Methods
extension PostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PostCell
        cell.label.text = post.title
        cell.votes.text = "\(post.votes)"
        return cell
    }
}
    
//MARK: - Table View Delegate Methods
extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: K.postToPostDetails, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.pulse()
    }
}

//MARK: - Protocol, isAbleToReceiveData
extension PostViewController: isAbleToReceiveData {
    func pass(title: String, body: String, sender: String) {
        firebaseManager.sendPost(title: title, body: body, sender: sender)
        firebaseManager.loadPostData(collection: K.FStore.postCollectionName, lat: WelcomeViewController.lat, lon: WelcomeViewController.lon, sender: self)
    }
}

//MARK: - Protocol, isAbleToDeleteData
extension PostViewController : isAbleToDeleteData {
    func pass(documentID: String) {
        firebaseManager.deletePost(documentID: documentID)
    }
}
