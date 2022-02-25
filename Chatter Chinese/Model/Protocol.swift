//
//  Protocol.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/23/22.
//

import Foundation

protocol isAbleToReceiveData {
    func pass(title: String, body: String, sender: String)
}

protocol isAbleToDeleteData {
    func pass(documentID: String)
}
