//
//  UsersTableViewCell.swift
//  peopart-app
//
//  Created by Leo Dion on 5/30/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import SwiftUI

//class UsersTableViewCell: UITableViewCell {
struct UserItemView : View {
  let user : UserEmbeddedProtocol
  var body: some View {
    Text(user.user.name)
  }
}
//  @IBOutlet weak var avatarImageView: UIImageView!
//  @IBOutlet weak var nameLabel: UILabel!
//  @IBOutlet weak var badgeLabel: UILabel!
//  @IBOutlet weak var summaryLabel: UILabel!
//
//  override func awakeFromNib() {
//    super.awakeFromNib()
//    // Initialization code
//  }
//
//  override func setSelected(_ selected: Bool, animated: Bool) {
//    super.setSelected(selected, animated: animated)
//
//    // Configure the view for the selected state
//  }
//
//}