//
//  ViewController.swift
//  TextInputBar
//
//  Created by Aryan Ghassemi on 8/16/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TextInputBarDelegate, UITableViewDataSource {
	
	@IBOutlet fileprivate var inputbar: TextInputbar!
	@IBOutlet fileprivate var tableView: UITableView!
	fileprivate var messages = [Message]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		populateInitialData()
		
		inputbar.textView.font = UIFont.systemFont(ofSize: 16)
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.separatorStyle = .none
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
		
		let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		
		DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
			
			self?.tableView.beginUpdates()
			let indexPath = IndexPath(row: self!.messages.count, section: 0)
			self?.messages.append(Message(text: textInputbar.textView.text, isMeAuthor: true))
			self?.tableView.insertRows(at: [indexPath], with: .left)
			self?.tableView.endUpdates()
			
			textInputbar.showProgress(false, animated: true)
			textInputbar.textView.text = ""
		}
	}
	
	// MARK: - UITableViewDataSource -
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
		cell.configureWithText(messages[(indexPath as NSIndexPath).row])
		return cell
	}
	
}

