//
//  CardsTableViewController.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 3/16/22.
//

import UIKit
import CoreData

class CardsTableViewController: UITableViewController {

    var sentenceArray = [Sentence()]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSentences()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadSentences()
    }
    
    // MARK: - Table View Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentenceArray.count
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = sentenceArray[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .center
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.pulse()
    }
    
    //MARK: - Defined Functions
    func loadSentences(with request: NSFetchRequest <Sentence> = Sentence.fetchRequest()) {
        do {
            sentenceArray = try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        tableView.reloadData()
    }
}
