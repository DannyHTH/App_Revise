//
//  TopicsViewController.swift
//  Memorize
//
//  Created by admin on 21/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicList.delegate = self
        topicList.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startAnimating()
        LocalMemory.changeToSubject(self.subject)
        self.topicList.reloadData()
        spinner.stopAnimating()
    }
    
    
    var subject:String!
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var topicList: UITableView!
    
    
    @IBAction func practice(_ sender: UIButton) {
        //TODO: implement practice
    }
    
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        let addTopicWindow = UIAlertController(title: "Add Topic", message: "Enter the topic.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "add", style: .default) { (_) in
            let topic = addTopicWindow.textFields?.first?.text
            if topic != nil && topic! != "" {
                for top in LocalMemory.subject!.topic! {
                    if top.name == topic {
                        let alert = UIAlertController(title: "Error", message: "Another topic with the name \'\(topic!)\' already exists.", preferredStyle: .alert)
                        let close = UIAlertAction(title: "close", style: .cancel, handler: nil)
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                LocalMemory.subject!.addTopic(Topic(topic!, withQuestionList: []))
                self.topicList.reloadData()
                self.saveTopicList()
            }
        }
        addTopicWindow.addAction(cancel)
        addTopicWindow.addTextField { (name) in
            name.placeholder = "Topic"
        }
        addTopicWindow.addAction(add)
        present(addTopicWindow, animated: true, completion: nil)
    }
    
    func saveTopicList() {
        LocalMemory.saveTopics()
    }
    
    func confirmationToDelete(_ topic:String) {
        let deleteTopicAlert = UIAlertController(title: "Delete Topic",
                                                 message: "Removing the topic will also permanently delete all the questions under this topic.\n\n Confirm to delete topic '\(topic)'?",
                                                 preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "delete", style: .destructive) { (_) in
            self.spinner.startAnimating()
            deleteTopic(withName: topic, for: LocalMemory.subject!.name)
            for index in LocalMemory.subject!.topic!.indices {
                if topic == LocalMemory.subject!.topic![index].name {
                    LocalMemory.subject!.topic!.remove(at: index)
                    break
                }
            }
            self.topicList.reloadData()
            self.spinner.stopAnimating()
        }
        deleteTopicAlert.addAction(cancel)
        deleteTopicAlert.addAction(delete)
        present(deleteTopicAlert, animated: true, completion: nil)
    }
    
    //MARK: - table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (LocalMemory.subject?.topic ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath)
        cell.textLabel?.text = LocalMemory.subject?.topic![indexPath.row].name
        let numberOfQuestions = LocalMemory.subject!.topic![indexPath.row].numQuestions
        var questionWord:String {
            get {
                if numberOfQuestions == 0 || numberOfQuestions == 1 {
                    return "question"
                } else {
                    return "questions"
                }
            }
        }
        cell.detailTextLabel?.text = "\(numberOfQuestions) \(questionWord)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmationToDelete(LocalMemory.subject!.topic![indexPath.row].name)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "view questions" {
            let questionViewController = segue.destination as? QuestionsViewController
            let cell = sender as? UITableViewCell
            let topic = cell?.textLabel?.text
            questionViewController?.topic = topic!
        } else if segue.identifier == "choose topic" {
            
        } else if segue.identifier == "practice" {
            
        }
    }
    

}
