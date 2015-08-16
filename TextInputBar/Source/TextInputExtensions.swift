//
//  TextInputExtensions.swift
//  TextInputToolbar
//
//  Created by Aryan Ghassemi on 8/16/15.
//  Copyright © 2015 Aryan Ghassemi. All rights reserved.
//

import UIKit

extension UIView {
	
	func constraintWithAttribute(attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
		for constraint in constraints where constraint.firstAttribute == attribute || constraint.secondAttribute == attribute  {
			if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
				
				return constraint
			}
		}
		
		return nil
	}
}
