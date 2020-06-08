//
//  Topic.swift
//  Memorize
//
//  Created by admin on 20/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import Foundation

class Topic {
    let name:String
    var question:[Question]? {
        didSet {
            if question != nil {
                numQuestions = question!.count
            }
        }
    }
    var numQuestions = 0
    
    init(_ name:String, withQuestionList qList:[Question]?) {
        self.name = name
        self.question = qList
    }
    
    func addQuestion(_ question:Question) {
        self.question?.append(question)
    }
    
    func deleteQuestion(withIndex index:Int) {
        self.question?.remove(at: index)
    }
    
    /**
     To get the index of the specified question in the question:[Question].
     
     - Return: the index of the question,
        nil if the specified question does not exist
     */
    func indexOf(_ question:String) -> Int? {
        if let questions = self.question{
            for index in questions.indices {
                if questions[index].question == question {
                    return index
                }
            }
        }
        return nil
    }
}

