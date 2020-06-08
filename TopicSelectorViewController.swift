//
//  TopicSelectorViewController.swift
//  Memorize
//
//  Created by admin on 13/4/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class TopicSelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        topicList.delegate = self
        topicList.dataSource = self
        stepper.minimumValue = 0
        stepper.maximumValue = 0
        stepper.value = 0
        stepper.autorepeat = true
        numberOfQuestionLabel.text = "Enter number of questions: \n(0 question available)"
        numQuestionInput.isEnabled = false
    }
    
    static var numberOfQuestionsToPractice = 0
    static var numberOfQuestionsAvailable = 0
    static var selectedTopicList:[String] = []
    
    static func addAvailQuestions(num:Int) {
        numberOfQuestionsAvailable += num
    }
    
    static func addTopic(_ topic:String) {
        selectedTopicList.append(topic)
    }
    
    static func removeTopic(_ topic:String) {
        let index = selectedTopicList.firstIndex(of: topic)
        selectedTopicList.remove(at: index!)
    }
    
    //MARK: - outlets
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var topicList: UITableView!
    @IBOutlet weak var numQuestionInput: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var practiceButton: UIBarButtonItem!
    
    
    //MARK: - actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            LocalMemory.practiceTopics = []
            LocalMemory.numberOfQuestions = 0
        }
    }
    
    @IBAction func changeNumberOfQuestions(_ sender: UIStepper) {
        stepper.maximumValue = Double(TopicSelectorViewController.numberOfQuestionsAvailable)
        self.numberOfQuestionLabel.text = "Enter number of questions: \n (\(stepper.maximumValue) questions available)"
        numQuestionInput.text = String(Int(stepper.value))
        TopicSelectorViewController.numberOfQuestionsToPractice = Int(stepper.value)
    }
    
    @IBAction func inputNumberOfQuestions(_ sender: UITextField) {
        stepper.value = Double(sender.text!) ?? 0
        TopicSelectorViewController.numberOfQuestionsToPractice = Int(sender.text!) ?? 0
    }
    
    @IBAction func practice(_ sender: UIBarButtonItem) {
        guard TopicSelectorViewController.numberOfQuestionsAvailable > 0 else {
            let alert = UIAlertController(title: "No subject selected", message: "Please select subject(s) and input number of questions to practice", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        let inputNumQuestions = Int(numQuestionInput.text!) ?? 0
        guard inputNumQuestions > 0 && inputNumQuestions <= TopicSelectorViewController.numberOfQuestionsAvailable else {
            let alert = UIAlertController(title: "Invalid Input", message: "The number of questions input is not valid.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel
                , handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        
        LocalMemory.practiceTopics = TopicSelectorViewController.selectedTopicList
        LocalMemory.numberOfQuestions = TopicSelectorViewController.numberOfQuestionsToPractice
        performSegue(withIdentifier: "practice", sender: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let maxNumberOfQuestions = TopicSelectorViewController.numberOfQuestionsAvailable
        stepper.maximumValue = Double(maxNumberOfQuestions)
        if (Int(numQuestionInput.text!) ?? 0) > maxNumberOfQuestions {
            numQuestionInput.text = String(maxNumberOfQuestions)
        }
        numberOfQuestionLabel.text = "Enter number of questions: \n(\(String(maxNumberOfQuestions)) questions availalbe)"
    }
    
    
    //MARK: - table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (LocalMemory.subject!.topic ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topicList.dequeueReusableCell(withIdentifier: "topic", for: indexPath)
        if let cell = cell as? topicCell {
            cell.topicLabel.text = LocalMemory.subject!.topic![indexPath.row].name
        let numQuestions = LocalMemory.subject!.topic![indexPath.row].numQuestions
            if numQuestions <= 1 {
                cell.numQuestionLabel.text = "\(numQuestions) question"
            } else {
                cell.numQuestionLabel.text = "\(numQuestions) questions"
            }
            return cell
        }
        return cell //dummy
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let practiceViewController = segue.destination as? PracticeViewController
        var questionPool:[Question] = []
        for topic in TopicSelectorViewController.selectedTopicList {
            LocalMemory.getQuestions(for: topic)
            let topicIndex = LocalMemory.subject!.indexOf(topic)
            questionPool.append(contentsOf: LocalMemory.subject!.topic![topicIndex!].question!)
        }
        //generate exercise
        let generator = ExerciseGenerator(withQuestions: questionPool)
        practiceViewController?.exercise = generator.generateExercise(numberOfQuestions: TopicSelectorViewController.numberOfQuestionsToPractice)
    }
    

}

class topicCell:UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var numQuestionLabel: UILabel!
    
    @IBOutlet weak var chooser: UISwitch!
    
    @IBAction func choiceChanged(_ sender: UISwitch) {
        let topic = self.topicLabel.text!
        let topicIndex = LocalMemory.subject!.indexOf(topic)
        let numQuestions = LocalMemory.subject!.topic![topicIndex!].numQuestions
        if sender.isOn {
            TopicSelectorViewController.addAvailQuestions(num: numQuestions)
            TopicSelectorViewController.addTopic(topic)
        } else {
            TopicSelectorViewController.addAvailQuestions(num: -numQuestions)
            TopicSelectorViewController.removeTopic(topic)
        }
    }
    
}
