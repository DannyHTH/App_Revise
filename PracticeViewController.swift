//
//  PracticeViewController.swift
//  Memorize
//
//  Created by admin on 12/4/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.isEditable = false
        answerField.isEditable = true
        setScene()
    }
    
    
    func setScene() {
        if questionNumber == totalNumberOfQuestions - 1 {
            nextButton.title = "Finish"
        } else {
            nextButton.title = "Next"
        }
        
        if !isReviewing {
            headerBar.title = "Question \(questionNumber+1)/\(totalNumberOfQuestions)"
            questionField.text = exercise.questionList[questionNumber].question
            answerField.text = ""
        } else {
            headerBar.title = "(Review) Question \(questionNumber+1)/\(totalNumberOfQuestions)"
            questionField.text = "\(exercise.questionList[questionNumber].question) \n\nAnswer: \n\(exercise.questionList[questionNumber].answer)"
            let answer = exercise.attemptedAnswers[questionNumber]
            answerField.text = answer
            if answer != exercise.questionList[questionNumber].answer {
                answerField.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                answerField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    
    let totalNumberOfQuestions = LocalMemory.numberOfQuestions
    var questionNumber = 0
    
    var exercise:Exercise!
    
    var isReviewing = false {
        didSet {
            if isReviewing == true {
                answerField.isEditable = false
            }
        }
    }
    
    
    //MARK: - outlets
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var headerBar: UINavigationItem!
    
    @IBOutlet weak var questionField: UITextView!
    @IBOutlet weak var answerField: UITextView!
    
    
    //MARK: - actions
    @IBAction func toNextQuestion(_ sender: UIBarButtonItem) {
        if sender.title == "Next" {
            exercise.attempt(for: questionNumber, with: answerField.text)
            questionNumber += 1
            setScene()
        } else {
            if self.isReviewing {
                self.dismiss(animated: true, completion: nil)
                return
            }
            exercise.attempt(for: questionNumber, with: answerField.text)
            let result = UIAlertController(title: "Practice Result", message: "Your practice score: \n \(exercise.numberOfCorrectQuestions())/\(totalNumberOfQuestions)", preferredStyle: .alert)
            let finish = UIAlertAction(title: "Finish", style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            let review = UIAlertAction(title: "Review", style: .default) { (_) in
                self.isReviewing = true
                self.questionNumber = 0
                self.setScene()
            }
            result.addAction(finish)
            result.addAction(review)
            present(result, animated: true, completion: nil)
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
