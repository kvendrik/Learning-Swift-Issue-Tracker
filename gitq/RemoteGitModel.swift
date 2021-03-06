//
//  IssueModel.swift
//  issue-tracker
//
//  Created by Koen Vendrik on 19/12/15.
//  Copyright © 2015 Koen Vendrik. All rights reserved.
//

import Alamofire

class RemoteGit {
    let apiHostUrl = "https://api.github.com"
    
    private func reqBase(URL: String, completionHandler: (NSArray?, Dictionary<String, AnyObject>?) -> Void){
        Alamofire.request(.GET, URL)
            .responseJSON {
                response in
                switch response.result {
                case .Success(let JSON):
                    let statusCode = response.response!.statusCode

                    if statusCode == 200 {
                        completionHandler(JSON as? NSArray, nil)
                    } else {
                        completionHandler(nil, [
                            "statusCode": statusCode
                        ])
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func getRepoIssues(repoFullName: String, completionHandler: (NSArray?, Dictionary<String, AnyObject>?) -> Void) {
        let URL = "\(apiHostUrl)/repos/\(repoFullName)/issues"
        reqBase(URL, completionHandler: completionHandler)
    }
    
    func getRepos(userName: String, isOrg: Bool, completionHandler: (NSArray?, Dictionary<String, AnyObject>?) -> Void){
        let URL = "\(apiHostUrl)/\(isOrg ? "orgs" : "users")/\(userName)/repos"
        reqBase(URL, completionHandler: completionHandler)
    }
    
    func getOrgs(userName: String, completionHandler: (NSArray?, Dictionary<String, AnyObject>?) -> Void){
        let URL = "\(apiHostUrl)/users/\(userName)/orgs"
        reqBase(URL, completionHandler: completionHandler)
    }
    
}
