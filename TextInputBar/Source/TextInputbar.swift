//
//  File.swift
//  TextInputToolbar
//
//  Created by Aryan Ghassemi on 8/15/15.
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

@objc public protocol TextInputBarDelegate: NSObjectProtocol, UIToolbarDelegate {
	func textInputBar(didSelectSend textInputbar: TextInputbar)
}

@IBDesignable public class TextInputbar: UIToolbar {
	
	@IBOutlet public weak var scrollView: UIScrollView?
	public let textView = PlaceholderTextView()
	public let sendButton = UIButton()
	public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
	private var textViewBarButtonItem: UIBarButtonItem!
	private var sendButtonBarButtonItem: UIBarButtonItem!
	private var activityIndicatorBarButtonItem: UIBarButtonItem!
	private var keyboardVisibleHeight: CGFloat = 0
	private var delegateInterceptor: TextInputBarDelegate?
	
	override public var delegate: UIToolbarDelegate? {
		didSet {
			if let delegate = delegate {
				let castedDelegate = unsafeBitCast(delegate, TextInputBarDelegate.self)
				delegateInterceptor = castedDelegate
			}
			else {
				delegateInterceptor = nil
			}
		}
	}
	
	@IBInspectable public var textViewPadding: CGFloat = 5 {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	@IBInspectable public var maxTextHeight: CGFloat = 100 {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	// MARK: - Initialization -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		customInitialization()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		customInitialization()
	}
	
	public override func layoutSubviews() {
		sendButton.sizeToFit()
		
		activityIndicatorBarButtonItem.width = sendButtonBarButtonItem.width
		
		let sendButtonWith: CGFloat = items!.contains(sendButtonBarButtonItem) ? sendButton.frame.size.width : 0
		let activityIndicatorWidth: CGFloat = items!.contains(activityIndicatorBarButtonItem) ? sendButton.frame.size.width : 0
		// WTF don't hardcode 35, use constraintWithAttribute instead
		let textViewWidth: CGFloat = frame.size.width - (sendButtonWith + activityIndicatorWidth) - 35
		var textViewHeight: CGFloat = textView.sizeThatFits(CGSizeMake(textViewWidth, CGFloat.max)).height
		textView.scrollEnabled = textViewHeight > maxTextHeight ? true : false
		textViewHeight = textViewHeight > maxTextHeight ? maxTextHeight : textViewHeight
		textView.frame = CGRectMake(textViewPadding, textViewPadding, textViewWidth, textViewHeight)
		
		constraintWithAttribute(.Height)?.constant = textView.frame.size.height + textViewPadding * 2
		superview?.constraintWithAttribute(.Bottom)?.constant = keyboardVisibleHeight * -1
		
		if let scrollView = scrollView {
			var newInset = scrollView.contentInset
			newInset.bottom = textViewHeight + (2 * textViewPadding) + keyboardVisibleHeight
			scrollView.contentInset = newInset
			scrollView.scrollIndicatorInsets = newInset
		}
		
		super.layoutSubviews()
	}
	
	private func customInitialization() {
		
		sendButton .setTitle("Send", forState: .Normal)
		sendButton.setTitleColor(.blackColor(), forState: .Normal)
		sendButton.addTarget(self, action: "sendButtonSelected:", forControlEvents: .TouchUpInside)
		sendButton.titleLabel?.font = UIFont.systemFontOfSize(15)
		sendButtonBarButtonItem = UIBarButtonItem(customView: sendButton)
		
		textView.placeholderText = "Type a message..."
		textView.layer.borderWidth = 0.6
		textView.layer.borderColor = UIColor.lightGrayColor().CGColor
		textView.layer.cornerRadius = 3
		textViewBarButtonItem = UIBarButtonItem(customView: textView)
		
		activityIndicatorView.color = .blackColor()
		activityIndicatorView.startAnimating()
		activityIndicatorBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
		
		setItems([textViewBarButtonItem], animated: false)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "keyboardWillChangeFrameNotificationRecieved:",
			name: UIKeyboardWillChangeFrameNotification,
			object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "keyboardWillChangeFrameNotificationRecieved:",
			name: UIKeyboardWillChangeFrameNotification,
			object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textDidChangeNotification:",
			name: UITextViewTextDidChangeNotification,
			object: textView)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: - Public -
	
	public func showProgress(progress: Bool, animated: Bool) {
		let items: [UIBarButtonItem] = progress
			? [textViewBarButtonItem, activityIndicatorBarButtonItem]
			: [textViewBarButtonItem, sendButtonBarButtonItem]
		
		setItems(items, animated: animated)
	}
	
	// MARK: - Actions -
	
	func sendButtonSelected(sender: UIButton) {
		delegateInterceptor?.textInputBar(didSelectSend: self)
	}
	
	// MARK: - NSNotification -
	
	func textDidChangeNotification(note: NSNotification) {
		let newItems: [UIBarButtonItem]
		
		if textView.text.isEmpty {
			newItems = [textViewBarButtonItem]
		}
		else {
			newItems = [textViewBarButtonItem, sendButtonBarButtonItem]
		}
		
		if newItems.count != items?.count {
			setItems(newItems, animated: true)
		}
		
		UIView.animateWithDuration(0.15) { [weak self] in
			self?.setNeedsLayout()
			self?.layoutIfNeeded()
		}
	}
	
	func keyboardWillChangeFrameNotificationRecieved(note: NSNotification) {
		
		if  let userInfo = note.userInfo,
			let window = window,
			let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(),
			let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0,
			let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
				
				let animationCurveRaw = animationCurveRawNSN.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
				let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
				let offset: CGFloat = endFrame.origin.y + endFrame.size.height - window.frame.size.height
				keyboardVisibleHeight = endFrame.size.height - offset;
				
				UIView.animateWithDuration(duration, delay: 0, options: animationCurve, animations: { [weak self] in
					
					self?.setNeedsLayout()
					self?.layoutIfNeeded()
					
					}, completion: nil)
		}
	}
}
