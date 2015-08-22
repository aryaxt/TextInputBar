//
//  TextInputAccessoryView.swift
//  TextInputBar
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

@objc protocol TextInputAccessoryViewDelegate {
	func textInputAccessoryView(didChnageToFrame rect: CGRect)
}

class TextInputAccessoryView: UIView {
	
	weak var delegate: TextInputAccessoryViewDelegate!
	private var isObserving = false
	private let keyPathsToObserve = ["frame", "center"]
	private let myContext = UnsafeMutablePointer<()>()
	
	// MARK: - Initialization -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		userInteractionEnabled = false
        backgroundColor = UIColor.clearColor()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		removeObserversIfNeeded()
	}
	
	// MARK: - UIView Methods -
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if let superview = superview {
			delegate.textInputAccessoryView(didChnageToFrame: superview.frame)
		}
	}
	
	override func willMoveToSuperview(newSuperview: UIView?) {
		removeObserversIfNeeded()
		
		for path in keyPathsToObserve {
			newSuperview?.addObserver(self, forKeyPath: path, options: .New, context: myContext)
		}
		
		isObserving = true
		
		super.willMoveToSuperview(newSuperview)
	}
	
	// MARK: - Private -
	
	func removeObserversIfNeeded() {
		if isObserving {
			for path in keyPathsToObserve {
				superview?.removeObserver(self, forKeyPath:path)
			}
		}
	}
	
	// MARK: - KBO -
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		
		if  let keyPath = keyPath,
			let superview = superview
			where object === superview && keyPathsToObserve.contains(keyPath) {
				
			delegate.textInputAccessoryView(didChnageToFrame: superview.frame)
		}
	}
	
}
