//
//  SessionListCell.swift
//  EEChat
//
//  Created by Snow on 2021/5/25.
//

import UIKit
import OpenIM
import OpenIMUI

class SessionListCell: UITableViewCell {
    
    @IBOutlet var avatarView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var unreadLabel: UILabel!

    var model: OIMConversation! {
        didSet {
            if model.userID != "" {
                if let user = OUIKit.shared.getUser(model.userID) {
                    avatarView.setImage(with: user.icon,
                                        placeholder: UIImage(named: "icon_default_avatar"))
                    nameLabel.text = user.getName()
                }
            } else {
                avatarView.setImage(with: URL(string: model.faceUrl),
                                    placeholder: UIImage(named: "icon_default_avatar"))
                nameLabel.text = model.showName
            }
            
            let (timestamp, text): (TimeInterval, String) = {
                if model.draftText != "" {
                    return (model.draftTimestamp, model.draftText)
                }
                let message = model.latestMsg!.toUIMessage()
                return (message.sendTime, LocalizedString(message.content.description))
            }()
            
            contentLabel.text = text
            timeLabel.text = OIMDateFormatter.shared.format(timestamp)
            
            unreadLabel.superview?.isHidden = model.unreadCount == 0
            unreadLabel.text = model.unreadCount < 99 ? model.unreadCount.description : "99+"
        }
    }
    
}