//
//  Constants.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import Foundation

struct K {
    static let appName = "Chatter Chinese"
    static let welcomeToRegisterSegue = "WelcomeToRegister"
    static let postToAddPost = "PostToAddPost"
    static let postToPostDetails = "PostToPostDetails"
    static let cafeToCafeDetails = "CafeToCafeDetails"
    static let cellIdentifier = "ReusableCell"
    static let messageCellNib = "MessageCell"
    static let postCellNib = "PostCell"
    static let distanceInKm = 20
    
    struct Colors {
        static let darkGreen = "DarkGreen"
        static let normalGreen = "NormalGreen"
        static let lighterGreen = "LighterGreen"
        static let lightGreen = "LightGreen"
    }
    
    struct FStore {
        static let userCollectionName = "users"
        static let usernameField = "user"
        static let ageField = "age"
        static let genderField = "gender"
        static let emailField = "email"
        static let latField = "lat"
        static let lonField = "lon"
        
        static let messageCollectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        
        static let postCollectionName = "posts"
        static let titleField = "title"
        static let voteField = "vote"
        static let voterField = "voters"
        static let docID = "id"
        
        static let languageField = "language"
        
        // Cafe
        static let cafeCollectionName = "cafe"
        static let locationField = "location"
        static let locationAddressField = "address"
        static let arriveField = "arrivalTime"
        static let departField = "departTime"
    }
}
