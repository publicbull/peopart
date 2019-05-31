//
//  Database.swift
//  peopart-app
//
//  Created by Leo Dion on 5/30/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct Database : DatabaseProtocol {
  
  let dataset : Dataset
  
  public static let defaultSource : DataSource = .bundle(Bundle.main, withResource: "db", andExtension: "json")
  public static let shared: DatabaseProtocol = try! Database()
  
  private init (source: DataSource = defaultSource) throws {
    
    let dbData = try source.getData()
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .formatted({
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
      return formatter
      }())
    let tables = try jsonDecoder.decode(Dataset.self, from: dbData)
    self.dataset = tables
  }
  
  public func users(_ completion: @escaping (Result<[UserEmbeddedProtocol], Error>) -> Void) {
    // sort by active users
    // add all posts of the users
    DispatchQueue.global().async {
      
      let postDictionary = [UUID : [Post]](grouping: self.dataset.posts, by: { (post) -> UUID in
        return post.userId
      }).mapValues { (posts) -> [Post] in
        posts.sorted(by: { (lhs, rhs) -> Bool in
          return lhs.date > rhs.date
        })
      }
      
      let usersEmbeddeds = self.dataset.users.map { (user) -> UserEmbeddedProtocol in
        return UserEmbedded(user: user, posts: postDictionary[user.id] ?? [PostProtocol]())
        }.sorted(by: { (lhs, rhs) -> Bool in
          lhs.posts.count > rhs.posts.count
        })
      
      completion(.success(usersEmbeddeds))
    }
    
    
  }
  
  func posts(_ completion: @escaping (Result<[PostEmbeddedProtocol], Error>) -> Void) {
    DispatchQueue.global().async {
      let commentDictionary = [UUID : [Comment]](grouping: self.dataset.comments, by: { (comment) -> UUID in
        return comment.postId
      }).mapValues({ (comments) -> [Comment] in
        return comments.sorted(by: { (lhs, rhs) -> Bool in
          return lhs.date > rhs.date
        })
      })
      
      let userDictionary = [UUID : [User]](grouping: self.dataset.users, by: { (user) -> UUID in
        return user.id
      }).compactMapValues({ (users) -> User? in
        return users.first
      })
      
      let posts = self.dataset.posts.compactMap({ (post) -> PostEmbeddedProtocol? in
        guard let author = userDictionary[post.userId] else {
          return nil
        }
        
        return PostEmbedded(post: post, author: author, comments: commentDictionary[post.id] ?? [CommentProtocol]())
      }).sorted(by: { (lhs, rhs) -> Bool in
        return lhs.post.date > rhs.post.date
      })
      
      completion(.success(posts))
    }
  }
}