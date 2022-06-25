//
//  UserRepositoryTranslator.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

struct UserRepositoryTranslator: Translator {
    func translate(_ data: Data) -> [UserRepositoryModel] {
        let models = self.parse(data: data)
        return models
    }

    /// パース
    func parse(data: Data) -> [UserRepositoryModel] {
        var models = [UserRepositoryModel]()
        
        guard let jsons = try? JSONSerialization.jsonObject(with: data) as? Array<Dictionary<String,Any>> else {
            return models
        }
        
        
        for json in jsons {
            guard let model = self.parseUser(dic: json) else {
                continue
            }
            
            models.append(model)
        }
        
        return models
    }
    
    func parseUser(dic: Dictionary<String,Any>) -> UserRepositoryModel? {
        let model = UserRepositoryModel(id: dic["id"] as? Int,
                                        nodeId: dic["node_id"] as? String,
                                        name: dic["name"] as? String,
                                        fullName: dic["full_name"] as? String,
                                        isPrivate: dic["private"] as? Bool,
                                        owner: self.parseOwner(dic: dic),
                                        htmlUrl: dic["html_url"] as? String,
                                        description: dic["description"] as? String,
                                        isFork: dic["fork"] as? Bool,
                                        url: dic["description"] as? String,
                                        forksUrl: dic["forks_url"] as? String,
                                        keysUrl: dic["keys_url"] as? String,
                                        collaboratorsUrl: dic["collaborators_url"] as? String,
                                        teamsUrl: dic["teams_url"] as? String,
                                        hooksUrl: dic["hooks_url"] as? String,
                                        issueEventsUrl: dic["issue_events_url"] as? String,
                                        eventsUrl: dic["events_url"] as? String,
                                        assigneesUrl: dic["assignees_url"] as? String,
                                        branchesUrl: dic["branches_url"] as? String,
                                        tagsUrl: dic["tags_url"] as? String,
                                        blobsUrl: dic["blobs_url"] as? String,
                                        gitTagsUrl: dic["git_tags_url"] as? String,
                                        gitRefsUrl: dic["git_refs_url"] as? String,
                                        treesUrl: dic["trees_url"] as? String,
                                        statusesUrl: dic["statuses_url"] as? String,
                                        languagesUrl: dic["languages_url"] as? String,
                                        stargazersUrl: dic["stargazers_url"] as? String,
                                        contributorsUrl: dic["contributors_url"] as? String,
                                        subscribersUrl: dic["subscribers_url"] as? String,
                                        subscriptionUrl: dic["subscription_url"] as? String,
                                        commitsUrl: dic["commits_url"] as? String,
                                        gitCommitsUrl: dic["git_commits_url"] as? String,
                                        commentsUrl: dic["comments_url"] as? String,
                                        issueCommentUrl: dic["issue_comment_url"] as? String,
                                        contentsUrl: dic["contents_url"] as? String,
                                        compareUrl: dic["compare_url"] as? String,
                                        mergesUrl: dic["merges_url"] as? String,
                                        archiveUrl: dic["archive_url"] as? String,
                                        downloadsUrl: dic["downloads_url"] as? String,
                                        issuesUrl: dic["issues_url"] as? String,
                                        pullsUrl: dic["pulls_url"] as? String,
                                        milestonesUrl: dic["milestones_url"] as? String,
                                        notificationsUrl: dic["notifications_url"] as? String,
                                        labelsUrl: dic["labels_url"] as? String,
                                        releasesUrl: dic["releases_url"] as? String,
                                        deploymentsUrl: dic["deployments_url"] as? String,
                                        createdAt: Utility.dateFromString(string: dic["created_at"] as? String,
                                                                          format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"),
                                        updatedAt: Utility.dateFromString(string: dic["updated_at"] as? String,
                                                                          format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"),
                                        pushedAt: Utility.dateFromString(string: dic["pushed_at"] as? String,
                                                                         format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"),
                                        gitUrl: dic["git_url"] as? String,
                                        sshUrl: dic["ssh_url"] as? String,
                                        cloneUrl: dic["clone_url"] as? String,
                                        svnUrl: dic["svn_url"] as? String,
                                        homepage: dic["homepage"] as? String,
                                        size: dic["size"] as? Int,
                                        stargazersCount: dic["stargazers_count"] as? Int,
                                        watchersCount: dic["watchers_count"] as? Int,
                                        language: dic["language"] as? String,
                                        isHasIssues: dic["has_issues"] as? Bool,
                                        isHasProjects: dic["has_projects"] as? Bool,
                                        isHasDownloads: dic["has_downloads"] as? Bool,
                                        isHasWiki: dic["has_wiki"] as? Bool,
                                        isHasPages: dic["has_pages"] as? Bool,
                                        isForksCount: dic["forks_count"] as? Bool,
                                        mirrorUrl: dic["mirror_url"] as? String,
                                        isArchived: dic["archived"] as? Bool,
                                        isDisabled: dic["disabled"] as? Bool,
                                        openIssuesCount: dic["open_issues_count"] as? Int,
                                        license: dic["license"] as? String,
                                        isAllowForking: dic["allow_forking"] as? Bool,
                                        isTemplate: dic["is_template"] as? Bool,
                                        visibility: dic["visibility"] as? String,
                                        forks: dic["forks"] as? Int,
                                        openIssues: dic["open_issues"] as? Int,
                                        watchers: dic["watchers"] as? Int,
                                        defaultBranch: dic["default_branch"] as? String)
        
        return model
        
    }
    
    func parseOwner(dic: Dictionary<String,Any>) -> UserRepositoryOwnerModel? {
        guard let dic = dic["owner"] as? Dictionary<String,Any> else {
            return nil
        }
        
        let model = UserRepositoryOwnerModel(login: dic["login"] as? String,
                                             id: dic["id"] as? Int,
                                             nodeId: dic["node_id"] as? String,
                                             avatarUrl: dic["avatar_url"] as? String,
                                             gravatarId: dic["gravatar_id"] as? String,
                                             url: dic["url"] as? String,
                                             htmlUrl: dic["html_url"] as? String,
                                             followersUrl: dic["followers_url"] as? String,
                                             followingUrl: dic["following_url"] as? String,
                                             gistsUrl: dic["gists_url"] as? String,
                                             starredUrl: dic["starred_url"] as? String,
                                             subscriptionsUrl: dic["subscriptions_url"] as? String,
                                             organizationsUrl: dic["organizations_url"] as? String,
                                             reposUrl: dic["repos_url"] as? String,
                                             eventsUrl: dic["events_url"] as? String,
                                             receivedEventsUrl: dic["received_events_url"] as? String,
                                             type: dic["type"] as? String,
                                             isSiteAdmin: dic["site_admin"] as? Bool)
        return model
        
    }
}
