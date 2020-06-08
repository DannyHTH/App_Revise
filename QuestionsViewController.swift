//
//  QuestionsViewController.swift
//  Memorize
//
//  Created by admin on 22/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionList.delegate = self
        questionList.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startAnimating()
        LocalMemory.getQuestions(for: topic)
        self.questionList.reloadData()
        spinner.stopAnimating()
    }
    
    var topic:String!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var questionList: UITableView!
    
    
    
    
    //MARK: - table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let topicIndex = LocalMemory.subject!.indexOf(topic)
        return (LocalMemory.subject!.topic![topicIndex!].question ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath)
        let topicIndex = LocalMemory.subject!.indexOf(topic)
        let questions = LocalMemory.subject!.topic![topicIndex!].question
        if let questions = questions {
            cell.textLabel?.text = questions[indexPath.row].question
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "add question" {
            let addQuestionViewController = segue.destination as? AddQuestionViewController
            addQuestionViewController?.topic = self.topic
        } else if segue.identifier == "edit question" {
            let editQuestionViewController = segue.destination as? EditQuestionViewController
            let cell = sender as? UITableViewCell
            let question = cell?.textLabel?.text
            let topicIndex = LocalMemory.subject!.indexOf(topic)
            let questionIndex = LocalMemory.subject!.topic![topicIndex!].indexOf(question!)
            editQuestionViewController?.question = LocalMemory.subject!.topic![topicIndex!].question![questionIndex!]
            editQuestionViewController?.topic = self.topic
            editQuestionViewController?.questionIndex = questionIndex
        }
        
    }
    

}
