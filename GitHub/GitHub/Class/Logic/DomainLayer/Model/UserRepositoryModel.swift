//
//  UserRepositoryModel.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

class UserRepositoryModel {
    let id: Int?
    let nodeId: String?
    let name: String?
    let fullName: String?
    let isPrivate: Bool?
    let owner: UserRepositoryOwnerModel?
    let htmlUrl: String?
    let description: String?
    let isFork: Bool?
    let url: String?
    let forksUrl: String?
    let keysUrl: String?
    let collaboratorsUrl: String?
    let teamsUrl: String?
    let hooksUrl: String?
    let issueEventsUrl: String?
    let eventsUrl: String?
    let assigneesUrl: String?
    let branchesUrl: String?
    let tagsUrl: String?
    let blobsUrl: String?
    let gitTagsUrl: String?
    let gitRefsUrl: String?
    let treesUrl: String?
    let statusesUrl: String?
    let languagesUrl: String?
    let stargazersUrl: String?
    let contributorsUrl: String?
    let subscribersUrl: String?
    let subscriptionUrl: String?
    let commitsUrl: String?
    let gitCommitsUrl: String?
    let commentsUrl: String?
    let issueCommentUrl: String?
    let contentsUrl: String?
    let compareUrl: String?
    let mergesUrl: String?
    let archiveUrl: String?
    let downloadsUrl: String?
    let issuesUrl: String?
    let pullsUrl: String?
    let milestonesUrl: String?
    let notificationsUrl: String?
    let labelsUrl: String?
    let releasesUrl: String?
    let deploymentsUrl: String?
    let createdAt: Date?
    let updatedAt: Date?
    let pushedAt: Date?
    let gitUrl: String?
    let sshUrl: String?
    let cloneUrl: String?
    let svnUrl: String?
    let homepage: String?
    let size: Int?
    let stargazersCount: Int?
    let watchersCount: Int?
    let language: String?
    let isHasIssues: Bool?
    let isHasProjects: Bool?
    let isHasDownloads: Bool?
    let isHasWiki: Bool?
    let isHasPages: Bool?
    let isForksCount: Bool?
    let mirrorUrl: String?
    let isArchived: Bool?
    let isDisabled: Bool?
    let openIssuesCount: Int?
    let license: String?
    let isAllowForking: Bool?
    let isTemplate: Bool?
    // topics
    let visibility: String?
    let forks: Int?
    let openIssues: Int?
    let watchers: Int?
    let defaultBranch: String?
    
    init(id: Int?,
         nodeId: String?,
         name: String?,
         fullName: String?,
         isPrivate: Bool?,
         owner: UserRepositoryOwnerModel?,
         htmlUrl: String?,
         description: String?,
         isFork: Bool?,
         url: String?,
         forksUrl: String?,
         keysUrl: String?,
         collaboratorsUrl: String?,
         teamsUrl: String?,
         hooksUrl: String?,
         issueEventsUrl: String?,
         eventsUrl: String?,
         assigneesUrl: String?,
         branchesUrl: String?,
         tagsUrl: String?,
         blobsUrl: String?,
         gitTagsUrl: String?,
         gitRefsUrl: String?,
         treesUrl: String?,
         statusesUrl: String?,
         languagesUrl: String?,
         stargazersUrl: String?,
         contributorsUrl: String?,
         subscribersUrl: String?,
         subscriptionUrl: String?,
         commitsUrl: String?,
         gitCommitsUrl: String?,
         commentsUrl: String?,
         issueCommentUrl: String?,
         contentsUrl: String?,
         compareUrl: String?,
         mergesUrl: String?,
         archiveUrl: String?,
         downloadsUrl: String?,
         issuesUrl: String?,
         pullsUrl: String?,
         milestonesUrl: String?,
         notificationsUrl: String?,
         labelsUrl: String?,
         releasesUrl: String?,
         deploymentsUrl: String?,
         createdAt: Date?,
         updatedAt: Date?,
         pushedAt: Date?,
         gitUrl: String?,
         sshUrl: String?,
         cloneUrl: String?,
         svnUrl: String?,
         homepage: String?,
         size: Int?,
         stargazersCount: Int?,
         watchersCount: Int?,
         language: String?,
         isHasIssues: Bool?,
         isHasProjects: Bool?,
         isHasDownloads: Bool?,
         isHasWiki: Bool?,
         isHasPages: Bool?,
         isForksCount: Bool?,
         mirrorUrl: String?,
         isArchived: Bool?,
         isDisabled: Bool?,
         openIssuesCount: Int?,
         license: String?,
         isAllowForking: Bool?,
         isTemplate: Bool?,
         visibility: String?,
         forks: Int?,
         openIssues: Int?,
         watchers: Int?,
         defaultBranch: String?) {
        
        self.id = id
        self.nodeId = nodeId
        self.name = name
        self.fullName = fullName
        self.isPrivate = isPrivate
        self.owner = owner
        self.htmlUrl = htmlUrl
        self.description = description
        self.isFork = isFork
        self.url = url
        self.forksUrl = forksUrl
        self.keysUrl = keysUrl
        self.collaboratorsUrl = collaboratorsUrl
        self.teamsUrl = teamsUrl
        self.hooksUrl = hooksUrl
        self.issueEventsUrl = issueEventsUrl
        self.eventsUrl = eventsUrl
        self.assigneesUrl = assigneesUrl
        self.branchesUrl = branchesUrl
        self.tagsUrl = tagsUrl
        self.blobsUrl = blobsUrl
        self.gitTagsUrl = gitTagsUrl
        self.gitRefsUrl = gitRefsUrl
        self.treesUrl = treesUrl
        self.statusesUrl = statusesUrl
        self.languagesUrl = languagesUrl
        self.stargazersUrl = stargazersUrl
        self.contributorsUrl = contributorsUrl
        self.subscribersUrl = subscribersUrl
        self.subscriptionUrl = subscriptionUrl
        self.commitsUrl = commitsUrl
        self.gitCommitsUrl = gitCommitsUrl
        self.commentsUrl = commentsUrl
        self.issueCommentUrl = issueCommentUrl
        self.contentsUrl = contentsUrl
        self.compareUrl = compareUrl
        self.mergesUrl = mergesUrl
        self.archiveUrl = archiveUrl
        self.downloadsUrl = downloadsUrl
        self.issuesUrl = issuesUrl
        self.pullsUrl = pullsUrl
        self.milestonesUrl = milestonesUrl
        self.notificationsUrl = notificationsUrl
        self.labelsUrl = labelsUrl
        self.releasesUrl = releasesUrl
        self.deploymentsUrl = deploymentsUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
        self.gitUrl = gitUrl
        self.sshUrl = sshUrl
        self.cloneUrl = cloneUrl
        self.svnUrl = svnUrl
        self.homepage = homepage
        self.size = size
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.language = language
        self.isHasIssues = isHasIssues
        self.isHasProjects = isHasProjects
        self.isHasDownloads = isHasDownloads
        self.isHasWiki = isHasWiki
        self.isHasPages = isHasPages
        self.isForksCount = isForksCount
        self.mirrorUrl = mirrorUrl
        self.isArchived = isArchived
        self.isDisabled = isDisabled
        self.openIssuesCount = openIssuesCount
        self.license = license
        self.isAllowForking = isAllowForking
        self.isTemplate = isTemplate
        self.visibility = visibility
        self.forks = forks
        self.openIssues = openIssues
        self.watchers = watchers
        self.defaultBranch = defaultBranch
    }
}

class UserRepositoryOwnerModel {
    let login: String?
    let id: Int?
    let nodeId: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url: String?
    let htmlUrl: String?
    let followersUrl: String?
    let followingUrl: String?
    let gistsUrl: String?
    let starredUrl: String?
    let subscriptionsUrl: String?
    let organizationsUrl: String?
    let reposUrl: String?
    let eventsUrl: String?
    let receivedEventsUrl: String?
    let type: String?
    let isSiteAdmin: Bool?
    
    init(login: String?,
         id: Int?,
         nodeId: String?,
         avatarUrl: String?,
         gravatarId: String?,
         url: String?,
         htmlUrl: String?,
         followersUrl: String?,
         followingUrl: String?,
         gistsUrl: String?,
         starredUrl: String?,
         subscriptionsUrl: String?,
         organizationsUrl: String?,
         reposUrl: String?,
         eventsUrl: String?,
         receivedEventsUrl: String?,
         type: String?,
         isSiteAdmin: Bool?) {
        self.login = login
        self.id = id
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.gistsUrl = gistsUrl
        self.starredUrl = starredUrl
        self.subscriptionsUrl = subscriptionsUrl
        self.organizationsUrl = organizationsUrl
        self.reposUrl = reposUrl
        self.eventsUrl = eventsUrl
        self.receivedEventsUrl = receivedEventsUrl
        self.type = type
        self.isSiteAdmin = isSiteAdmin
    }
}
