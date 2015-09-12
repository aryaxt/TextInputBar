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
	private var messages = [Message]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		populateInitialData()
		
		inputbar.textView.font = UIFont.systemFontOfSize(16)
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.separatorStyle = .None
		tableView.tableFooterView = UIView()
	}
	
	// MARK: - Private -
	
	func populateInitialData() {
		messages.append(Message(text: "Hey", isMeAuthor: true))
		messages.append(Message(text: "What's up?", isMeAuthor: false))
		messages.append(Message(text: "I love this component, it saves me a lot of time, and it looks great. I use it in all my apps", isMeAuthor: true))
		messages.append(Message(text: "I'm glad you liked it", isMeAuthor: false))
		messages.append(Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with", isMeAuthor: true))
		messages.append(Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\ne specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", isMeAuthor: false))
	}
	
	// MARK: - TextInputToolbarDelegate -
	
	func textInputBar(didSelectSend textInputbar: TextInputbar) {
		textInputbar.showProgress(true, animated: true)
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
		
		dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
			
			self?.tableView.beginUpdates()
			let indexPath = NSIndexPath(forRow: self!.messages.count, inSection: 0)
			self?.messages.append(Message(text: textInputbar.textView.text, isMeAuthor: true))
			self?.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
			self?.tableView.endUpdates()
			
			textInputbar.showProgress(false, animated: true)
			textInputbar.textView.text = ""
		}
	}
	
	// MARK: - UITableViewDataSource -
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
		cell.configureWithText(messages[indexPath.row])
		return cell
	}
	
}

