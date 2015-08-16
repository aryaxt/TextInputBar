//
//  TextInputTextView.swift
//  TextInputToolbar
//
//  Created by Aryan Ghassemi on 8/16/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//
//	https://github.com/aryaxt/TextInputBar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

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
