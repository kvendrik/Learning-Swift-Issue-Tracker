//
//  IssueTrackerTableVC.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 19/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

import UIKit

class IssueTableVC: UITableViewController {
    
    @IBOutlet weak var loadingAIV: UIActivityIndicatorView!
    
    var refreshRC:UIRefreshControl!
    var issueItems: [IssueItem] = []
    
    var repoFullName: String = ""
    var tappedCellIdx: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = 135.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadingAIV.startAnimating()
        getData() {
            self.loadingAIV.stopAnimating()
            self.loadingAIV.hidden = true
        }
        
        initPullToRefresh()
    }
    
    func initPullToRefresh(){
        refreshRC = UIRefreshControl()
        refreshRC.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshRC.addTarget(self, action: "pulledToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshRC)
    }
    
    func pulledToRefresh(){
        getData() {
            self.refreshRC.endRefreshing()
        }
    }
    
    func getData(onDataLoaded: () -> Void){
        let remoteGit = RemoteGit()
        
        issueItems = []

        remoteGit.getRepoIssues(repoFullName) {
            results, err in
            
            if results!.count < 1 {

                let emptyLabel = UILabel()
                emptyLabel.textAlignment = NSTextAlignment.Center
                emptyLabel.text = "No issues here, yeey!"
                
                self.tableView.backgroundView = emptyLabel
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

            } else {
            
                for result in results! {
                    let author = result["user"] as! Dictionary<String, AnyObject>
                    self.issueItems.append(IssueItem(
                        number: result["number"] as! Int,
                        title: result["title"] as! String,
                        state: result["state"] as! String,
                        assignee: result["assignee"] as? String,
                        createdAt: result["created_at"] as! String,
                        author: [
                            "login": author["login"] as! String,
                            "avatarUrl": author["avatar_url"] as! String
                        ],
                        labels: result["labels"] as! [Dictionary<String, AnyObject>]
                    ))
                }
            
                self.tableView.reloadData()
            }

            onDataLoaded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return issueItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssueTableViewCell", forIndexPath: indexPath) as! IssueTableViewCell
        
        let issueItem = issueItems[indexPath.row]
        
        cell.idLabel.text = "#\(issueItem.number)"
        cell.titleLabel.text = issueItem.title
        cell.assigneeLabel.text = issueItem.assignee
        cell.dateLabel.text = "opened on \(issueItem.getPrettyCreatedAtStr())"
        cell.authorLabel.text = "by \(issueItem.author["login"]!)"
        cell.labelsLabel.text = issueItem.getLabelsStr()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tappedCellIdx = indexPath.row
        performSegueWithIdentifier("IssueDetailSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "IssueDetailSegue" {
            let issueItem = issueItems[tappedCellIdx]

            let svc = segue.destinationViewController as! IssueDetailVC
            svc.issueItem = issueItem
        }
    }

}
