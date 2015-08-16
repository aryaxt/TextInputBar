//
//  TextInputTextView.swift
//  TextInputToolbar
//
//  Created by Aryan Ghassemi on 8/16/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

@IBDesignable public class PlaceholderTextView: UITextView {
	
	private var placeholderTextView: UITextView!
	@IBInspectable public var placeholderText: String? {
		didSet {
			placeholderTextView.text = placeholderText
		}
	}
	
	@IBInspectable public var placeholderTextColor: UIColor? {
		didSet {
			placeholderTextView.textColor = placeholderTextColor
		}
	}
	
	// MARK: - Initialize -
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		initialize()
	}
	
	private func initialize() {
		placeholderTextView = UITextView(frame: bounds)
		placeholderTextView.editable = false
		placeholderTextView.scrollEnabled = false
		placeholderTextView.userInteractionEnabled = false
		placeholderTextView.textColor = UIColor.lightGrayColor()
		placeholderTextView.backgroundColor = UIColor.clearColor()
		addSubview(placeholderTextView)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textViewDidChangeTextNotification:",
			name: UITextViewTextDidChangeNotification,
			object: self)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: - UIView Methods -
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		placeholderTextView.frame = bounds
		placeholderTextView.contentOffset = contentOffset
		placeholderTextView.contentInset = contentInset
		placeholderTextView.font = font
		
		updatePlaceholderVisibility()
	}
	
	// MARK: - NSNotification -
	
	func textViewDidChangeTextNotification(notification: NSNotification) {
		updatePlaceholderVisibility()
	}
	
	// MARK: - Private -
	
	private func updatePlaceholderVisibility() {
		placeholderTextView.hidden = text.isEmpty ? false : true
	}
	
}
