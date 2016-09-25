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

@IBDesignable open class TextInputbar: UIToolbar, TextInputTextViewDelegate, TextInputAccessoryViewDelegate {
	
	@IBOutlet open weak var scrollView: UIScrollView?
	open let textView = TextInputTextView()
	open let sendButton = UIButton()
	open let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
	fileprivate let textViewPadding: CGFloat = 5
	fileprivate var textViewBarButtonItem: UIBarButtonItem!
	fileprivate var sendButtonBarButtonItem: UIBarButtonItem!
	fileprivate var activityIndicatorBarButtonItem: UIBarButtonItem!
	fileprivate var keyboardVisibleHeight: CGFloat = 0
	fileprivate var delegateInterceptor: TextInputBarDelegate?
	fileprivate let accessoryView = TextInputAccessoryView()
	
	override open var delegate: UIToolbarDelegate? {
		didSet {
			if let delegate = delegate {
				let castedDelegate = unsafeBitCast(delegate, to: TextInputBarDelegate.self)
				delegateInterceptor = castedDelegate
			}
			else {
				delegateInterceptor = nil
			}
		}
	}
	
	@IBInspectable open var maxTextHeight: CGFloat = 100 {
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
	
	open override func layoutSubviews() {
		sendButton.sizeToFit()
		
		activityIndicatorBarButtonItem.width = sendButtonBarButtonItem.width
		
        let appropriateTextViewSize = appropriateSizeForTextView()
        textView.frame = CGRect(x: 0, y: 0, width: appropriateTextViewSize.width, height: appropriateTextViewSize.height)
		
		constraintWithAttribute(.height)?.constant = textView.frame.size.height + textViewPadding * 2
        
        if let bottomGuideConstraint = superview?.constraintWithAttribute(.bottom, includesView: self) {
            let constant = bottomGuideConstraint.firstItem === self ? keyboardVisibleHeight * -1 : keyboardVisibleHeight
            bottomGuideConstraint.constant = constant
        }
		
		if let scrollView = scrollView {
			var newInset = scrollView.contentInset
            
            // iOS9 automatically adjusts insets of scrollview
//            if  let parentViewController = parentViewController
//                where UIDevice.currentDevice().systemVersionGreaterOrEqualTo("9") && parentViewController.automaticallyAdjustsScrollViewInsets {
//                newInset.bottom = appropriateTextViewSize.height + (2 * textViewPadding)
//            }
//            else {
//                newInset.bottom = appropriateTextViewSize.height + (2 * textViewPadding) + keyboardVisibleHeight
//            }

			newInset.bottom = appropriateTextViewSize.height + (2 * textViewPadding) + keyboardVisibleHeight
			
			scrollView.contentInset = newInset
			scrollView.scrollIndicatorInsets = newInset
		}
		
		super.layoutSubviews()
	}
	
	fileprivate func customInitialization() {
		
		accessoryView.delegate = self
		
		sendButton .setTitle("Send", for: UIControlState())
		sendButton.setTitleColor(UIColor.black, for: UIControlState())
		sendButton.addTarget(self, action: #selector(TextInputbar.sendButtonSelected(_:)), for: .touchUpInside)
		sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
		sendButtonBarButtonItem = UIBarButtonItem(customView: sendButton)
		
		textView.placeholderText = "Type a message..."
		textView.layer.borderWidth = 0.6
		textView.layer.borderColor = UIColor.lightGray.cgColor
		textView.layer.cornerRadius = 3
		textView.delegate = self
		textView.inputAccessoryView = accessoryView
		textViewBarButtonItem = UIBarButtonItem(customView: textView)
        
        if UIDevice.current.systemVersionLessThan("9") {
            // http://stackoverflow.com/questions/26038082/uitextview-settext-should-not-jump-to-top-in-ios8
            textView.layoutManager.allowsNonContiguousLayout = false
        }
		
		activityIndicatorView.color = UIColor.black
		activityIndicatorView.startAnimating()
		activityIndicatorBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
		
		setItems([textViewBarButtonItem], animated: false)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(TextInputbar.keyboardWillChangeFrameNotificationRecieved(_:)),
			name: NSNotification.Name.UIKeyboardWillChangeFrame,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(TextInputbar.keyboardWillChangeFrameNotificationRecieved(_:)),
			name: NSNotification.Name.UIKeyboardWillChangeFrame,
			object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - Public -
	
	open func showProgress(_ progress: Bool, animated: Bool) {
		let items: [UIBarButtonItem] = progress
			? [textViewBarButtonItem, activityIndicatorBarButtonItem]
			: textView.text.isEmpty ? [textViewBarButtonItem, sendButtonBarButtonItem] : [textViewBarButtonItem, sendButtonBarButtonItem]
		
		setItems(items, animated: animated)
	}
	
	// MARK: - Private -
    
    fileprivate func appropriateSizeForTextView() -> CGSize {
        // WTF don't hardcode 35, use constraintWithAttribute instead
        let sendButtonWith: CGFloat = items!.contains(sendButtonBarButtonItem) ? sendButton.frame.size.width : 0
        let activityIndicatorWidth: CGFloat = items!.contains(activityIndicatorBarButtonItem) ? sendButton.frame.size.width : 0
        let textViewWidth: CGFloat = frame.size.width - (sendButtonWith + activityIndicatorWidth) - 35
        var textViewHeight: CGFloat = textView.sizeThatFits(CGSize(width: textViewWidth, height: CGFloat.greatestFiniteMagnitude)).height
        textViewHeight = textViewHeight > maxTextHeight ? maxTextHeight : textViewHeight
        
        return CGSize(width: textViewWidth, height: textViewHeight)
    }
	
	fileprivate func updateStateBasedOnTextChange() {
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

        if !textView.frame.size.equalTo(appropriateSizeForTextView()) {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }) 
        }
	}
	
	// MARK: - TextInputAccessoryViewDelegate -
	
	open func textInputAccessoryView(didChnageToFrame rect: CGRect) {
		
		if let window = superview?.window {
			keyboardVisibleHeight = window.frame.size.height - (rect.origin.y)
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	// MARK: - Actions -
	
	func sendButtonSelected(_ sender: UIButton) {
		delegateInterceptor?.textInputBar(didSelectSend: self)
	}
	
	// MARK: - TextInputTextViewDelegate -
	
	open func textViewDidChange(_ textView: UITextView) {
		updateStateBasedOnTextChange()
	}
	
	open func textInputTextView(didSetText textInputTextView: TextInputTextView) {
		updateStateBasedOnTextChange()
	}
	
	open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return !items!.contains(activityIndicatorBarButtonItem)
	}
	
	// MARK: - NSNotification -
	
	func keyboardWillChangeFrameNotificationRecieved(_ note: Notification) {
		
		if  let userInfo = (note as NSNotification).userInfo,
			let window = window,
			let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
			let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0,
			let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
				
                let animationCurveRaw = animationCurveRawNSN.uintValue ?? UIViewAnimationOptions().rawValue
                let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                let y = endFrame.origin.y == CGFloat.infinity ? 0 : endFrame.origin.y
                let height = endFrame.size.height == CGFloat.infinity ? 0 : endFrame.size.height
                let offset: CGFloat = y + height - window.frame.size.height
                keyboardVisibleHeight = height - offset;
				
				UIView.animate(withDuration: duration, delay: 0, options: animationCurve, animations: { [weak self] in
					
					self?.setNeedsLayout()
					self?.layoutIfNeeded()
					
					}, completion: nil)
		}
	}
}
