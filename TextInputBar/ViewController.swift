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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		inputbar.textView.text = "This is a test\nThis is a test\nThis is a test"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		view.endEditing(true)
	}
	
	// MARK: - TextInputToolbarDelegate -
	
	func textInputBar(didSelectSend textInputbar: TextInputbar) {
		textInputbar.showProgress(true, animated: true)
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
		
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			textInputbar.showProgress(false, animated: true)
			textInputbar.textView.text = ""
		}
	}
	
	// MARK: - UITableViewDataSource -
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 25
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("test")
		cell?.textLabel?.text = "Cell number \(indexPath.row)"
		return cell!
	}
}

