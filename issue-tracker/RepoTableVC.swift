//
//  RepoTableVC.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 20/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

//
//  IssueTrackerTableVC.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 19/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

import UIKit

class RepoTableVC: UITableViewController {

    @IBOutlet weak var loadingAIV: UIActivityIndicatorView!
    
    var refreshRC:UIRefreshControl!

    var userRepos = [String: [RepoItem]]()
    var tappedCellDetails = [String: Int]()
    
    let remoteGit = RemoteGit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
    
    func showMsgLabel(msgText: String){
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = NSTextAlignment.Center
        emptyLabel.text = msgText
        
        self.tableView.backgroundView = emptyLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func showErrorLabel(){
        showMsgLabel("Whoops looks like something went wrong, try again later")
    }
    
    func getData(onDataLoaded: () -> Void){
        self.getUserRepos("kvendrik", isOrg: false) {
            self.tableView.reloadData()
        }

        remoteGit.getOrgs("kvendrik") {
            orgs, err in
            
            if err != nil {
                self.showErrorLabel()
                return
            }
            
            for org in orgs! {
                self.getUserRepos(org["login"] as! String, isOrg: true) {
                    self.tableView.reloadData()
                }
            }
            
            onDataLoaded()
        }
    }
    
    func getUserRepos(userName: String, isOrg: Bool, onDataLoaded: () -> Void){
        if(userRepos[userName] == nil){
            userRepos[userName] = [RepoItem]()
        }
        
        let repos = self.userRepos[userName]

        remoteGit.getRepos(userName, isOrg: isOrg) {
            results, err in
            
            if err != nil {
                self.showErrorLabel()
                return
            }
            
            for result in results! {
                let owner = result["owner"] as! Dictionary<String, AnyObject>
                let fullName = result["full_name"] as! String

                let itemDetails = RepoItem(
                    name: result["name"] as! String,
                    fullName: fullName,
                    isPrivate: result["private"] as! Bool,
                    ownerLogin: owner["login"] as! String
                )
                
                var foundInArray = false

                for repo in repos! {
                    if repo.fullName == fullName {
                        foundInArray = true
                    }
                }

                if !foundInArray {
                    self.userRepos[userName]!.append(itemDetails)
                }
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
        return Array(userRepos.keys).count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let keyName = Array(userRepos.keys)[section]
        return userRepos[keyName]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let keyName = Array(userRepos.keys)[indexPath.section]
        let repoItem = userRepos[keyName]![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RepoTableViewCell", forIndexPath: indexPath) as! RepoTableViewCell
        cell.repoNameLabel.text = repoItem.fullName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return Array(userRepos.keys)[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tappedCellDetails = [
            "row": indexPath.row,
            "section": indexPath.section
        ]
        performSegueWithIdentifier("RepoIssuesSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "RepoIssuesSegue" {
            let keyName = Array(userRepos.keys)[tappedCellDetails["section"]!]
            let repoItem = userRepos[keyName]![tappedCellDetails["row"]!]
            
            let svc = segue.destinationViewController as! IssueTableVC;
            svc.repoFullName = repoItem.fullName
        }
    }
    
}

