//
//  File.swift
//  Memorize
//
//  Created by admin on 24/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import Foundation

class LocalMemory {
    
    //MARK: - the list of subjects in memory
    static var subjectList:[String]?
    
    static func getSubjectList() {
        let database = UserDefaults.standard
        let subjects = database.value(forKey: DatabaseItem.subjectNameList) as? [String]
        self.subjectList = subjects ?? []
    }
    
    static func saveSubjectList() {
        let database = UserDefaults.standard
        database.set(subjectList!, forKey: DatabaseItem.subjectNameList)
    }
    //MARK: - the current opened subject
    static var subject:Subject?
    
    static func resetSubject() {
        self.subject = nil
    }
    
    static func changeToSubject(_ subject:String) {
        self.subject = Subject(subject, withTopicList: [])
        let database = UserDefaults.standard
        let topicList = database.value(forKey: DatabaseItem.topicNameList + subject) as? [String]
        if topicList == nil {
            return
        }
        for topic in topicList! {
            let numQuestions = database.value(forKey: DatabaseItem.numberOfQuestions + topic + subject) as? Int
            let topicObject = Topic(topic, withQuestionList: nil)
            topicObject.numQuestions = numQuestions ?? 0
            self.subject?.addTopic(topicObject)
        }
    }
    
    static func getQuestions(for topic:String) {
        guard self.subject != nil else {
            print("Illegal attempt to get questions while subject is not set.")
            return
        }
        let database = UserDefaults.standard
        let questionList = database.value(forKey: DatabaseItem.questionList + topic + self.subject!.name) as? [String:String]
        let index = self.subject!.indexOf(topic)
        guard index != nil else {
            print("Topic \(topic) does not exist.")
            return
        }
        self.subject!.topic![index!].question = []
        if let questionList = questionList{
            for question in questionList.keys {
                self.subject!.topic![index!].addQuestion(Question(question, withAns: questionList[question]!))
            }
        }
    }
    
    static func saveTopics() {
        guard self.subject != nil else {
            print("Illegal attempt to save topics while subject is not set.")
            return
        }
        var topicList:[String] = []
        for topic in self.subject!.topic! {
            topicList.append(topic.name)
        }
        UserDefaults.standard.set(topicList, forKey: DatabaseItem.topicNameList + self.subject!.name)
    }
    
    static func saveQuestions(for topic:String) {
        guard self.subject != nil else {
            print("Illegal attempt to save questions while subject is not set.")
            return
        }
        let index = self.subject!.indexOf(topic)
        guard index != nil else {
            print("Topic \(topic) does not exist.")
            return
        }
        let questionList = self.subject!.topic![index!].question
        if questionList == nil {
            return
        }
        var questions:[String:String] = [:]
        for question in questionList! {
            questions.updateValue(question.answer, forKey: question.question)
        }
        UserDefaults.standard.set(questions, forKey: DatabaseItem.questionList + topic + self.subject!.name)
        UserDefaults.standard.set(questions.count, forKey: DatabaseItem.numberOfQuestions + topic + self.subject!.name)
    }
    
    //MARK: - practice memory
    static var practiceTopics:[String] = []
    static var numberOfQuestions = 0
}
