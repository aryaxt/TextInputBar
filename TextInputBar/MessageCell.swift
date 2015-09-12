//
//  MessageCell.swift
//  TextInputBar
//
//  Created by Aryan Ghassemi on 8/29/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

public class MessageCell: UITableViewCell {
	
	@IBOutlet private var messageLabel: UILabel!
	@IBOutlet private var messageLabelContainerView: UIView!
	@IBOutlet private var leftLayoutConstraint: NSLayoutConstraint!
	@IBOutlet private var rightLayoutConstraint: NSLayoutConstraint!
	private let blueColor = UIColor(colorLiteralRed: 0, green: 111/255, blue: 255/255, alpha: 1)
	private let greenColor = UIColor(colorLiteralRed: 56/255, green: 235/255, blue: 0, alpha: 1)
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		
		messageLabel.textColor = .whiteColor()
		messageLabel.numberOfLines = 0
		messageLabelContainerView.layer.cornerRadius = 7
		messageLabelContainerView.clipsToBounds = true
	}
	
	public func configureWithText(message: Message) {
		messageLabel.text = message.text
		messageLabelContainerView.backgroundColor = message.isMeAuthor ? blueColor : greenColor
		leftLayoutConstraint.priority = message.isMeAuthor ? 750 : 250
		rightLayoutConstraint.priority = message.isMeAuthor ? 250 : 750
	}
	
}
