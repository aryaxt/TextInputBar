//
//  ViewController.swift
//  TextInputBar
//
//  Created by Aryan Ghassemi on 8/16/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TextInputBarDelegate, UITableViewDataSource {
	
	@IBOutlet private var inputbar: TextInputbar!
	@IBOutlet private var tableView: UITableView!
	private var comments = ["Hello", "Hey this is a test\nThis was posted in multiple lines", "Nice"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		inputbar.textView.text = "This is a test\nThis is a test\nThis is a test"
		
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - TextInputToolbarDelegate -
	
	func textInputBar(didSelectSend textInputbar: TextInputbar) {
		textInputbar.showProgress(true, animated: true)
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
		
		dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
			
			self?.tableView.beginUpdates()
			let indexPath = NSIndexPath(forRow: self!.comments.count, inSection: 0)
			self?.comments.append(textInputbar.textView.text)
			self?.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			self?.tableView.endUpdates()
			
			textInputbar.showProgress(false, animated: true)
			textInputbar.textView.text = ""
		}
	}
	
	// MARK: - UITableViewDataSource -
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comments.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("test")
		cell?.textLabel?.text = comments[indexPath.row]
		cell?.textLabel?.font = UIFont.systemFontOfSize(15)
		cell?.textLabel?.numberOfLines = 0
		return cell!
	}
}

