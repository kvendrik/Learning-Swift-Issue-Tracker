//
//  IssueItem.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 19/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

import UIKit

struct IssueItem {
    let number: Int
    let title: String
    let state: String
    let assignee: String?
    let createdAt: String
    let author: Dictionary<String, String>
    let labels: [Dictionary<String, AnyObject>]
    
    func getLabelsStr() -> String {
        var labelsStr = ""
        for label in self.labels {
            labelsStr += "\(label["name"]!) "
        }

        return labelsStr
    }
    
    func getPrettyCreatedAtStr() -> String {
        if(self.createdAt == ""){
            return ""
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let dateObj = dateFormatter.dateFromString(self.createdAt)!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMMM YYYY"
        
        return dayTimePeriodFormatter.stringFromDate(dateObj)
    }
}
