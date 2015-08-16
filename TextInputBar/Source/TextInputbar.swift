//
//  File.swift
//  TextInputToolbar
//
//  Created by Aryan Ghassemi on 8/15/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

@objc public protocol TextInputBarDelegate: NSObjectProtocol, UIToolbarDelegate {
	func textInputBar(didSelectSend textInputbar: TextInputbar)
}

@IBDesignable public class TextInputbar: UIToolbar {
	
	public var textView: PlaceholderTextView!
	public var sendButton: UIButton!
	public var activityIndicatorView: UIActivityIndicatorView!
	private var textViewBarButtonItem: UIBarButtonItem!
	private var sendButtonBarButtonItem: UIBarButtonItem!
	private var activityIndicatorBarButtonItem: UIBarButtonItem!
	private var keyboardHeight: CGFloat = 0
	private var delegateInterceptor: TextInputBarDelegate?
	@IBOutlet public weak var scrollView: UIScrollView?
	
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
		let textViewHeight: CGFloat = textView.sizeThatFits(CGSizeMake(textViewWidth, CGFloat.max)).height
		textView.frame = CGRectMake(textViewPadding, textViewPadding, textViewWidth, textViewHeight)
		
		constraintWithAttribute(.Height)?.constant = textView.frame.size.height + textViewPadding * 2
		superview?.constraintWithAttribute(.Bottom)?.constant = keyboardHeight * -1
		
		if let scrollView = scrollView {
			var newInset = scrollView.contentInset
			newInset.bottom = textViewHeight + keyboardHeight;
			scrollView.contentInset = newInset
		}
		
		super.layoutSubviews()
	}
	
	private func customInitialization() {
		
		sendButton = UIButton(type: .Custom)
		sendButton .setTitle("Send", forState: .Normal)
		sendButton.setTitleColor(.blackColor(), forState: .Normal)
		sendButton.addTarget(self, action: "sendButtonSelected:", forControlEvents: .TouchUpInside)
		sendButton.titleLabel?.font = UIFont.systemFontOfSize(15)
		sendButtonBarButtonItem = UIBarButtonItem(customView: sendButton)
		
		textView = PlaceholderTextView()
		textView.placeholderText = "Type a message..."
		textView.layer.borderWidth = 0.6
		textView.layer.borderColor = UIColor.lightGrayColor().CGColor
		textView.layer.cornerRadius = 3
		textViewBarButtonItem = UIBarButtonItem(customView: textView)
		
		activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
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
				
				keyboardHeight = endFrame.size.height + endFrame.origin.y > window.frame.size.height ? 0 : endFrame.size.height
				
				UIView.animateWithDuration(duration, delay: 0, options: animationCurve, animations: { [weak self] in
					
					self?.setNeedsLayout()
					self?.layoutIfNeeded()
					
					}, completion: nil)
		}
	}
}
