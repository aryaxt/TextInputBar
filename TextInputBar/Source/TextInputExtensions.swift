//
//  TextInputExtensions.swift
//  TextInputToolbar
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

extension UIView {
	
    func constraintWithAttribute(_ attribute: NSLayoutAttribute, includesView: UIView? = nil) -> NSLayoutConstraint? {
        for constraint in constraints  {
            if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
                
                if let includesView = includesView {
                    if constraint.firstItem === includesView || constraint.secondItem === includesView {
                        return constraint
                    }
                }
                else {
                    return constraint
                }
            }
        }
        
        return nil
    }
    
    var parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = self
        
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
}

extension UIDevice {
    
    func systemVersionGreaterOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    func systemVersionLessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
}

