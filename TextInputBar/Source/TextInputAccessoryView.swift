//
//  TextInputAccessoryView.swift
//  TextInputBar
//
//  Created by Aryan Ghassemi on 8/16/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

@objc public protocol TextInputAccessoryViewDelegate {
	func textInputAccessoryView(didChnageToFrame rect: CGRect)
}

public class TextInputAccessoryView: UIView {
	
	public weak var delegate: TextInputAccessoryViewDelegate!
	private var superViewFrame: CGRect?
	private var isObserving = false
	private let keyPathsToObserve = ["frame", "center"]
	let myContext = UnsafeMutablePointer<()>()
	
	// MARK: - Initialization -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		userInteractionEnabled = false
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		removeObserversIfNeeded()
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		if let superview = superview {
			delegate.textInputAccessoryView(didChnageToFrame: superview.frame)
		}
	}
	
	public override func willMoveToSuperview(newSuperview: UIView?) {
		removeObserversIfNeeded()
		
		for path in keyPathsToObserve {
			newSuperview?.addObserver(self, forKeyPath: path, options: .New, context: myContext)
		}
		
		isObserving = true
		
		super.willMoveToSuperview(newSuperview)
	}
	
	// MARK: - Private -
	
	private func removeObserversIfNeeded() {
		if isObserving {
			for path in keyPathsToObserve {
				superview?.removeObserver(self, forKeyPath:path)
			}
		}
	}
	
	// MARK: - KBO -
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		
		if  let keyPath = keyPath,
			let superview = superview
			where object === superview && keyPathsToObserve.contains(keyPath) {
			delegate.textInputAccessoryView(didChnageToFrame: superview.frame)
		}
	}
	
}
