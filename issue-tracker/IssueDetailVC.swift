//
//  IssueDetailVC.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 20/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

import UIKit

class IssueDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var labelsLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    var issueItem: IssueItem = IssueItem(
        number: 0,
        title: "",
        state: "",
        assignee: "",
        createdAt: "",
        author: [
            "login": "",
            "avatarUrl": ""
        ],
        labels: []
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        titleLabel.text = issueItem.title
        numberLabel.text = "#\(issueItem.number)"
        statusLabel.text = issueItem.state
        createdAtLabel.text = "opened on \(issueItem.getPrettyCreatedAtStr())"
        authorLabel.text = "by \(issueItem.author["login"]!)"
        labelsLabel.text = issueItem.getLabelsStr()
        assigneeLabel.text = issueItem.assignee
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
