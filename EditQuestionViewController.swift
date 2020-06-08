//
//  EditQuestionViewController.swift
//  Memorize
//
//  Created by admin on 2/4/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class EditQuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.text = question.question
        answerField.text = question.answer
        questionField.isEditable = true
        answerField.isEditable = true
    }
    
    @IBOutlet weak var questionField: UITextView!
    @IBOutlet weak var answerField: UITextView!
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        self.question.question = questionField.text
        self.question.answer = answerField.text
        LocalMemory.subject!.topic![topicIndex].question![questionIndex] = self.question
        LocalMemory.saveQuestions(for: topic)
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func deleteQuestion(_ sender: UIBarButtonItem) {
        let deleteQuestionAlert = UIAlertController(title: "Delete Question",
                                                    message: "Confirm to delete the question?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "delete", style: .destructive) { (_) in
            LocalMemory.subject!.topic![self.topicIndex].question!.remove(at: self.questionIndex)
            LocalMemory.saveQuestions(for: self.topic)
            self.dismiss(animated: true, completion: nil)
        }
        deleteQuestionAlert.addAction(cancel)
        deleteQuestionAlert.addAction(delete)
        present(deleteQuestionAlert, animated: true, completion: nil)
    }
    
    var question:Question!
    var topic:String!
    var questionIndex:Int!
    var topicIndex:Int! {
        get {
            return LocalMemory.subject!.indexOf(topic)
        }
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
