//
//  User.swift
//  peopart-app
//
//  Created by Leo Dion on 5/30/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct User : UserProtocol, Codable {
  let id : UUID
  let name : String
  let avatar : URL
  let badge : String
}