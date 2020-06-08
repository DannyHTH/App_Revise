//
//  Question.swift
//  Memorize
//
//  Created by admin on 20/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import Foundation

class Question {
    var question:String
    var answer:String
    
    init(_ question:String, withAns ans:String) {
        self.question = question
        self.answer = ans
    }
}
