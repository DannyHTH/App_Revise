//
//  Subject.swift
//  Memorize
//
//  Created by admin on 20/3/2020.
//  Copyright © 2020 HTH. All rights reserved.
//

import Foundation

class Subject {
    let name:String
    var topic:[Topic]?
    
    init(_ name:String, withTopicList tList:[Topic]?) {
        self.name = name
        self.topic = tList
    }
    
    func addTopic(_ topic:Topic) {
        self.topic?.append(topic)
    }
    
    func deleteTopic(withIndex index:Int) {
        self.topic?.remove(at: index)
    }
    
    func indexOf(_ topic:String) -> Int? {
        if let topics = self.topic {
            for index in topics.indices {
                if topics[index].name == topic {
                    return index
                }
            }
        }
        return nil
    }
}
