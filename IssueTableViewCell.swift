//
//  IssueTrackerTableViewCell.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 19/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var labelsLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    
}

