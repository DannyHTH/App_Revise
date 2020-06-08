//
//  AddQuestionViewController.swift
//  Memorize
//
//  Created by admin on 22/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.isEditable = true
        answerField.isEditable = true
        if LocalMemory.subject!.topic![topicIndex!].question == nil {
            LocalMemory.getQuestions(for: topic)
        }
    }
    
    var topic:String!
    var topicIndex:Int? {
        return LocalMemory.subject!.indexOf(topic)
    }
    
    @IBOutlet weak var questionField: UITextView!
    @IBOutlet weak var answerField: UITextView!
    
    
    @IBAction func addQuestion(_ sender: UIBarButtonItem) {
        let question = questionField.text
        let answer = answerField.text
        guard question! != "" && answer! != "" else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        LocalMemory.subject!.topic![topicIndex!].addQuestion(Question(question!, withAns: answer!))
        LocalMemory.saveQuestions(for: self.topic)
        self.dismiss(animated: true,completion: nil)
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
