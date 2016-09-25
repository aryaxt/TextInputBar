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

@objc public protocol TextInputTextViewDelegate: NSObjectProtocol, UITextViewDelegate {
	func textInputTextView(didSetText textInputTextView: TextInputTextView)
}

@IBDesignable open class TextInputTextView: UITextView {
	
	fileprivate var placeholderTextView: UITextView!
	fileprivate var delegateInterceptor: TextInputTextViewDelegate?
	
	override open var delegate: UITextViewDelegate? {
		didSet {
			if let delegate = delegate {
				let castedDelegate = unsafeBitCast(delegate, to: TextInputTextViewDelegate.self)
				delegateInterceptor = castedDelegate
			}
			else {
				delegateInterceptor = nil
			}
		}
	}
	
	override open var text: String! {
		didSet {
			delegateInterceptor?.textInputTextView(didSetText: self)
		}
	}
	
	@IBInspectable open var placeholderText: String? {
		didSet {
			placeholderTextView.text = placeholderText
		}
	}
	
	@IBInspectable open var placeholderTextColor: UIColor? {
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
	
	fileprivate func initialize() {
		placeholderTextView = UITextView(frame: bounds)
		placeholderTextView.isEditable = false
		placeholderTextView.isScrollEnabled = false
		placeholderTextView.isUserInteractionEnabled = false
		placeholderTextView.textColor = UIColor.lightGray
		placeholderTextView.backgroundColor = UIColor.clear
		addSubview(placeholderTextView)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(TextInputTextView.textViewDidChangeTextNotification(_:)),
			name: NSNotification.Name.UITextViewTextDidChange,
			object: self)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - UIView Methods -
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		placeholderTextView.frame = bounds
		placeholderTextView.contentOffset = contentOffset
		placeholderTextView.contentInset = contentInset
		placeholderTextView.font = font
		updatePlaceholderVisibility()
	}
	
	// MARK: - NSNotification -
	
	func textViewDidChangeTextNotification(_ notification: Notification) {
		updatePlaceholderVisibility()
	}
	
	// MARK: - Private -
	
	fileprivate func updatePlaceholderVisibility() {
		placeholderTextView.isHidden = text.isEmpty ? false : true
	}
	
}
