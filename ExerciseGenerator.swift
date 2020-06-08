//
//  ExerciseGenerator.swift
//  Memorize
//
//  Created by admin on 13/4/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import Foundation

class ExerciseGenerator{
    var questionPool:[Question]
    var numberOfQusetions = 0
    
    init(withQuestions questionList:[Question]) {
        questionPool = questionList
    }
    
    func generateExercise(numberOfQuestions:Int) -> Exercise? {
        guard numberOfQuestions <= questionPool.count else {
            return nil
        }
        let questionIndices = generateRandomNumberList(from_0_to: questionPool.count-1, withElementCount: numberOfQuestions)
        var questionList:[Question] = []
        for index in questionIndices {
            questionList.append(questionPool[index])
        }
        return Exercise(withQuestions: questionList)
    }
    
    //input assertion: always legal inputs
    private func generateRandomNumberList(from_0_to max:Int, withElementCount count:Int) -> [Int] {
        var numPool:[Int] = []
        for num in 0...max {
            numPool.append(num)
        }
        return select(fromArray: numPool, withElementCount: count)
    }
    
    private func select(fromArray arr:[Int], withElementCount count:Int) -> [Int] {
        var result:[Int] = []
        var dumped:[Int] = []
        for num in arr {
            if Bool.random() {
                result.append(num)
            } else {
                dumped.append(num)
            }
        }
        if result.count == count {
            return result
        } else if result.count >= count {
            return select(fromArray: result, withElementCount: count)
        } else {
            let remaining = select(fromArray: dumped, withElementCount: count - result.count)
            for num in remaining {
                result.append(num)
            }
            return result
        }
    }
}

class Exercise{
    var questionList:[Question]
    var attemptedAnswers:[String]
    
    init(withQuestions questionList:[Question]) {
        self.questionList = questionList
        attemptedAnswers = [String](repeatElement("", count: questionList.count))
    }
    
    func attempt(for questionIndex:Int, with answer:String) {
        attemptedAnswers[questionIndex] = answer
    }
    
    func numberOfCorrectQuestions() -> Int {
        var correctCount = 0
        for index in 0...questionList.count-1 {
            if attemptedAnswers[index] == questionList[index].answer {
                correctCount += 1
            }
        }
        return correctCount
    }
}

