//
//  MessageCell.swift
//  TextInputBar
//
//  Created by Aryan Ghassemi on 8/29/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

open class MessageCell: UITableViewCell {
	
	@IBOutlet fileprivate var messageLabel: UILabel!
	@IBOutlet fileprivate var messageLabelContainerView: UIView!
	@IBOutlet fileprivate var leftLayoutConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var rightLayoutConstraint: NSLayoutConstraint!
	fileprivate let blueColor = UIColor(colorLiteralRed: 0, green: 111/255, blue: 255/255, alpha: 1)
	fileprivate let greenColor = UIColor(colorLiteralRed: 56/255, green: 235/255, blue: 0, alpha: 1)
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		
		messageLabel.textColor = UIColor.white
		messageLabel.numberOfLines = 0
		messageLabelContainerView.layer.cornerRadius = 7
		messageLabelContainerView.clipsToBounds = true
	}
	
	open func configureWithText(_ message: Message) {
		messageLabel.text = message.text
		messageLabelContainerView.backgroundColor = message.isMeAuthor ? blueColor : greenColor
		leftLayoutConstraint.priority = message.isMeAuthor ? 750 : 250
		rightLayoutConstraint.priority = message.isMeAuthor ? 250 : 750
	}
	
}
