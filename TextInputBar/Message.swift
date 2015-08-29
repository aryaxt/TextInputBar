//
//  File.swift
//  TextInputBar
//
//  Created by Aryan Ghassemi on 8/29/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

public class Message {
	
	let text: String
	let isMeAuthor: Bool
	
	init(text: String, isMeAuthor: Bool) {
		self.text = text
		self.isMeAuthor = isMeAuthor
	}
}
