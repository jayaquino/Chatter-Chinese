//
//  FirebaseManager.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/22/22.
//

import UIKit
import Firebase

protocol FirebaseManagerDelegate {
    func didUpdateMessages(_ firebaseManager: FirebaseManager, Messages: [Message])
    func didFailWithError(error: Error)
}

struct FirebaseManager {
    
    let database = Firestore.firestore()

    //MARK: - User
    func getUser() -> String {
        if let user = Auth.auth().currentUser?.email {
            return user
        } else {
            print("cannot get user")
            return ""
        }
    }
       
    
    func registerUser(email: String, password: String, segue: String, sender: UIViewController) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
            } else {
                DispatchQueue.main.async {
                    sender.performSegue(withIdentifier: segue, sender: sender)
                }
            }
        }
    }
    
    func registerUserInfo(username: String, age: String, gender: String, language: String, sender: UIViewController, email: String) {
        database.collection(K.FStore.userCollectionName).addDocument(data: [K.FStore.usernameField: username, K.FStore.ageField: age, K.FStore.genderField: gender, K.FStore.emailField: email, K.FStore.languageField: language]) { error in
            if let e = error {
                print(e)
            } else {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBar")
                       
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
        }
    }
    
    func signInUser(email: String, password: String, sender: UIViewController, completionHandler:@escaping(Bool)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
            } else {
                let usersRef = self.database.collection(K.FStore.userCollectionName)
                usersRef.whereField("email", isEqualTo: Auth.auth().currentUser?.email as Any).getDocuments() { (querySnapshot, error) in
                    if let e = error {
                        print("Error getting documents: \(e)")
                    } else {
                        if querySnapshot!.isEmpty {
                            completionHandler(false)
                        } else {
                            completionHandler(true)
                        }
                    }
                }
            }
        }
    }
    
    func getUsername(sender: ChatViewController) {
        let usersRef = self.database.collection(K.FStore.userCollectionName)
        usersRef.whereField("email", isEqualTo: Auth.auth().currentUser?.email as Any).getDocuments() { (querySnapshot, error) in
            if let e = error {
                print("Error getting username \(e)")
            } else {
                for document in querySnapshot!.documents {
                    sender.username = document.data()[K.FStore.usernameField] as! String
                }
            }
        }
    }
    
    func getLanguage(sender: ChatViewController) {
        let usersRef = self.database.collection(K.FStore.userCollectionName)
        usersRef.whereField("email", isEqualTo: Auth.auth().currentUser?.email as Any).getDocuments() { (querySnapshot, error) in
            if let e = error {
                print("Error getting username \(e)")
            } else {
                for document in querySnapshot!.documents {
                    sender.language = document.data()[K.FStore.languageField] as! String
                }
            }
        }
    }
    
    //MARK: - Section for Chat
    func sendChat(messageBody: String, messageSender: String, messageUsername: String, lat: Double, lon: Double, sender: ChatViewController) {
        database.collection(K.FStore.messageCollectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.usernameField: messageUsername, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970, K.FStore.latField: lat, K.FStore.lonField: lon]) {error in
            if let e = error {
                print(e)
            } else {
                DispatchQueue.main.async {
                    sender.messageTextField.text = ""
                }
            }
        }
    }
    
    func loadData(collection: String, lat: Double, lon: Double, sender: ChatViewController) {
        database.collection(collection)
            .order(by: K.FStore.dateField, descending: true)
            .addSnapshotListener { querySnapShot, error in
                if let snapShotDocuments = querySnapShot?.documents {
                    sender.data = []
                    var counter = 0
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageUsername = data[K.FStore.usernameField] as? String, let messageBody = data[K.FStore.bodyField] as? String, let messageLat = data[K.FStore.latField] as? Double, let messageLon = data[K.FStore.lonField] as? Double {
                            let newMessage = Message(sender: messageSender, username: messageUsername, body: messageBody)
                            // let d = 3963.0 * acos((sin(lat) * sin(messageLat)) + cos(lat) * cos(messageLat) * cos(messageLon ??? lon))
                            let d = 1.609344 * 3963 * acos(sin(lat/57.29577951) * sin(messageLat/57.29577951) + cos(lat/57.29577951) * cos(messageLat/57.29577951) * cos(messageLon/57.29577951 - lon/57.29577951))
                            print(d)
                            if d < 100 {
                                sender.data.append(newMessage)
                            }
                            DispatchQueue.main.async {
                                sender.tableView.reloadData()
                                // Scroll to the bottom of the tableview
                                let indexPath = IndexPath(row: sender.data.count-1, section: 0)
                                if sender.data.isEmpty {
                                } else {
                                    sender.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                        counter += 1
                        if counter == 100 {
                            break
                        }
                        
                    }
                }
            }
    }
    
    //MARK: - Section for Posts
    func loadPostData (collection: String, lat: Double, lon: Double, sender: PostViewController) {
        database.collection(collection)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapShot, error in
                if let snapShotDocuments = querySnapShot?.documents {
                    sender.data = []
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let postSender = data[K.FStore.senderField] as? String, let postBody = data[K.FStore.bodyField] as? String, let postTitle = data[K.FStore.titleField] as? String, let postVotes = data[K.FStore.voteField] as? Int {
                            let newPost = Post(sender: postSender, title: postTitle, body: postBody, votes: postVotes, id: doc.documentID)
                            sender.data.append(newPost)
                            DispatchQueue.main.async {
                                sender.tableView.reloadData()
                                // Scroll to the bottom of the tableview
                                let indexPath = IndexPath(row: sender.data.count-1, section: 0)
                                if sender.data.isEmpty {
                                } else {
                                    sender.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
    }
    
    func sendPost(title: String, body: String, sender: String) {
        database.collection(K.FStore.postCollectionName).addDocument(data: [K.FStore.senderField: sender, K.FStore.titleField: title, K.FStore.bodyField: body, K.FStore.voteField: Int(0), K.FStore.voterField: sender ,K.FStore.dateField: Date().timeIntervalSince1970]) {error in
            if let e = error {
                print(e)
            } else {
                
            }
        }
    }
    
    func deletePost(documentID: String) {
        database.collection(K.FStore.postCollectionName).document(documentID).delete()
    }
    
    func addVoter(userID: String, documentID: String) {
        database.collection(K.FStore.postCollectionName).document(documentID).updateData([
            K.FStore.voterField: FieldValue.arrayUnion([userID])])
    }
    
    func removeVoter(userID: String, documentID: String) {
        database.collection(K.FStore.postCollectionName).document(documentID).updateData([K.FStore.voterField: FieldValue.arrayRemove([userID])])
    }
    
    func getVotes(documentID: String) {
        
    }
    
    func updateVoteAmount(documentID: String, sender: PostDetailsViewController) {
        print("checking document...")
        database.collection(K.FStore.postCollectionName).document(documentID).getDocument(completion: { documentSnapshot, error in
            if let voters = documentSnapshot?.data()?[K.FStore.voterField] as? [String] {
                print(voters.count)
                database.collection(K.FStore.postCollectionName).document(documentID).updateData([
                    K.FStore.voteField: voters.count])
                sender.votesLabel.text = String(voters.count)
            }
            
        })
        
    }
    
    //MARK: - Section for Cafe
    
    func addAvailability (location: String, address: String, arriveTime: String, departTime: String) {
        database.collection(K.FStore.cafeCollectionName).addDocument(data: [K.FStore.locationField: location, K.FStore.locationAddressField: address,K.FStore.arriveField: arriveTime, K.FStore.departField: departTime,K.FStore.dateField: Date().timeIntervalSince1970]) {error in
            if let e = error {
                print(e)
            } else {

            }
        }
    }
    
}
