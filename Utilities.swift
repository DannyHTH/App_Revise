//
//  Utilities.swift
//  Memorize
//
//  Created by admin on 20/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import Foundation

struct DatabaseItem {
    static let subjectNameList = "subject name list"
    static let topicNameList = "topic name list"
    static let questionList = "question list"
    
    static let numberOfQuestions = "no. questions"
}

func deleteSubject(withName subject:String) {
    let database = UserDefaults.standard
    var subjectList = database.value(forKey: DatabaseItem.subjectNameList) as? [String]
    guard subjectList != nil else {
        return
    }
    for index in subjectList!.indices {
        if subject == subjectList![index] {
            let topicList = database.value(forKey: DatabaseItem.topicNameList + subject) as? [String]
            if let topicList = topicList {
                for topic in topicList {
                    deleteTopic(withName: topic, for: subject)
                }
            }
            database.removeObject(forKey: DatabaseItem.topicNameList + subject)
            subjectList!.remove(at: index)
            break
        }
    }
    database.set(subjectList!, forKey: DatabaseItem.subjectNameList)
}

func deleteTopic(withName topic:String, for subject:String) {
    let database = UserDefaults.standard
    var topicList = database.value(forKey: DatabaseItem.topicNameList + subject) as? [String]
    guard topicList != nil else {
        return
    }
    for index in topicList!.indices {
        if topic == topicList![index] {
            database.removeObject(forKey: DatabaseItem.questionList + topic + subject)
            database.removeObject(forKey: DatabaseItem.numberOfQuestions + topic + subject)
            topicList!.remove(at: index)
            break
        }
    }
    database.set(topicList!, forKey: DatabaseItem.topicNameList + subject)
}

func deleteQuestion(withQuestion question:String, for topic:String, of subject:String) {
    let database = UserDefaults.standard
    var questionList = database.value(forKey: DatabaseItem.questionList + topic + subject) as? [String:String]
    guard questionList != nil else {
        return
    }
    questionList!.removeValue(forKey: question)
    database.set(questionList!, forKey: DatabaseItem.questionList + topic + subject)
}
